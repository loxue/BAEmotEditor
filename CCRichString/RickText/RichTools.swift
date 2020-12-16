//
//  RichTools.swift
//  CCRichString
//
//  Created by myc on 2020/12/16.
//

import UIKit

protocol RichToolsDelegate: NSObjectProtocol {
    
    
    /// 操作richTools改变前
    ///
    /// - Parameters:
    ///   - richTools: <#richTools description#>
    ///   - type: <#type description#>
    ///   - textStyle: <#textStyle description#>
    func richText(richTools: RichTools, type: MainView.KeyItemType, beginDidChange textStyle: RichTextStyle)
    
    /// 操作richTools改变后
    ///
    /// - Parameters:
    ///   - richTools: <#richTools description#>
    ///   - type: <#type description#>
    ///   - textStyle: <#textStyle description#>
    func richText(richTools: RichTools, type: MainView.KeyItemType, endDidChange textStyle: RichTextStyle)
    
    /// 监控richTools位置变化
    ///
    /// - Parameters:
    ///   - richTools: richTools description
    ///   - form: 位置变化
    func richText(richTools: RichTools, affineTransform form: CGAffineTransform)
}



class RichTools: UIView {
    
    public var textStyle: RichTextStyle {
        get {
            let model = RichTextStyle()
            model.fontColor = self.colorView.getColor
            model.isBold = self.mainView.isBold
            model.fontSize = self.fontView.getFontSize
            return model
        }
    }
    
    public var delegate: RichToolsDelegate?

    private var hiddenBtn: UIButton!  // 隐藏键盘
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 44, width: UIScreen.main.bounds.size.width, height: 50))

        NotificationCenter.default.addObserver(self, selector:#selector(RichTools.keyBoardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(RichTools.keyBoardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.gray
        
        self.addSubview(self.scrollView)

        self.addSubview(self.closeBtn)
        
        self.scrollView.addSubview(self.mainView)
        self.scrollView.addSubview(self.colorView)
        self.scrollView.addSubview(self.fontView)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.5))
        line.backgroundColor = UIColor.red
        self.addSubview(line)
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - RichConfig.hiddenWidth, height: self.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    /// 主体功能块
    lazy var mainView: MainView = {
        let mainView = MainView()
        mainView.mainAction { (type) in
            self.swiftAction(isShow: true, type: type)
        }
        return mainView
    }()
    
    /// 字号块
    lazy var fontView: FontView = {
        let fontView = FontView()
        fontView.showAction(cellback: { (isShow) in
            if !isShow {
                self.swiftAction(isShow: isShow, type: .font)
            }
        })
        return fontView
    }()
    
    /// 颜色块
    lazy var colorView: ColorView = {
        let colorView = ColorView()
        colorView.showAction(cellback: { (isShow) in
            if !isShow {
                self.swiftAction(isShow: isShow, type: .color)
            }
        })
        return colorView
    }()
    
    
    /// 切换事件
    ///
    /// - Parameters:
    ///   - isShow: 是否显示
    ///   - type: 按钮类型
    private func swiftAction(isShow: Bool, type: MainView.KeyItemType) {
        if isShow {
            switch type {
            case .image:
                break
            case .font:
                self.mainView.isHidden = true
                self.closeBtn.type = .close
                self.fontView.isShow = true
                self.scrollView.contentSize.width = self.fontView.width
                
            case .bold: break
            case .color:
                self.mainView.isHidden = true
                self.closeBtn.type = .close
                self.colorView.isShow = true
                self.scrollView.contentSize.width = self.colorView.width
            }
            self.delegate?.richText(richTools: self, type: type, beginDidChange: self.textStyle)
        } else {
            self.mainView.isHidden = false
            self.scrollView.contentSize.width = self.mainView.width
            self.closeBtn.type = .editing
            self.mainView.btnColor = colorView.getColor
            self.delegate?.richText(richTools: self, type: type, endDidChange: self.textStyle)
        }
        
        
    }
    
    /// 关闭按钮
    lazy var closeBtn: CloseBtn = {
        let closeBtn = CloseBtn()
        closeBtn.close {
            self.colorView.isShow = false
            self.fontView.isShow = false
            closeBtn.type = .editing
        }
        return closeBtn
    }()

    /// 监视键盘显示
    ///
    /// - Parameter note: note description
    @objc private func keyBoardWillShow(_ note:Notification) {
        let userInfo  = note.userInfo
        let keyBoardBounds = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        self.convert(keyBoardBounds, to:nil)
        let deltaY = keyBoardBounds.height
        let animations:(() -> Void) = {
            self.transform = CGAffineTransform(translationX: 0,y: -deltaY)
            self.delegate?.richText(richTools: self, affineTransform: self.transform)
        }
        if duration > 0 {
            let options = UIView.AnimationOptions(rawValue: UInt((userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        } else {
            animations()
        }
    }
    
    
    /// 监视键盘隐藏
    ///
    /// - Parameter note: <#note description#>
    @objc private func keyBoardWillHide(_ note: Notification) {
        let userInfo  = note.userInfo
        let duration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        let animations:(() -> Void) = {
            self.transform = CGAffineTransform.identity
            self.delegate?.richText(richTools: self, affineTransform: self.transform)
        }
        if duration > 0 {
            let options = UIView.AnimationOptions(rawValue: UInt((userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        } else {
            animations()
        }
    }
    
    
    // 销毁
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}


extension RichTools: UIScrollViewDelegate {
    // 滚动触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -50 {
            self.colorView.isShow = false
            self.fontView.isShow = false
        }
    }
}

