//
//  MainView.swift
//  CCRichString
//
//  Created by myc on 2020/12/16.
//

import UIKit

extension MainView {
    
    public func mainAction(cellback: mainTouchUpInside?) {
        self.onClick = cellback
    }
}

class MainView: UIView {
    
    /// 是否是粗体
    public var isBold: Bool {
        get {
            if let boldBtn = self.viewWithTag(KeyItemType.bold.rawValue + 100) as? UIButton {
                return boldBtn.isSelected
            }
            return false
        }
    }
    
    public var btnColor: UIColor? {
        didSet {
            if let color = btnColor {
                let boldBtn = self.viewWithTag(KeyItemType.color.rawValue + 100) as? UIButton
                let image = boldBtn?.imageView?.image?.color(to: color)
                boldBtn?.setImage(image, for: .normal)
            }
        }
    }

    private var imageArray = [UIImage(named: "IconSource.bundle/icon_image"),
                              UIImage(named: "IconSource.bundle/icon_font"),
                              UIImage(named: "IconSource.bundle/icon_bold"),
                              UIImage(named: "IconSource.bundle/icon_color")]
    
    /// 键盘功能类型
    ///
    /// - keyBoard: 切换键盘
    /// - font: 字体大小、粗细、斜体、下划线、中划线
    /// - color: 字体颜色
    /// - image: 照片、相册
    /// - hidden: 隐藏
    enum KeyItemType: Int {
        case font = 1
        case color = 3
        case image = 0
        case bold = 2
    }
    
    typealias mainTouchUpInside = (_ type: KeyItemType) -> ()
    fileprivate var onClick: mainTouchUpInside?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: RichConfig.height))
        
        for i in 0..<self.imageArray.count {
            let button = UIButton(frame: CGRect(x: CGFloat(i) * RichConfig.mainItemWidth, y: 0, width: RichConfig.mainItemWidth, height: self.height))
            button.setImage(self.imageArray[i], for: .normal)
            button.tag = 100 + i
            if i == KeyItemType.bold.rawValue {
                button.setImage(self.imageArray[i]?.color(to: UIColor.orange), for: .selected)
            }
            button.addTarget(self, action: #selector(MainView.action(button:)), for: .touchUpInside)
            self.addSubview(button)
            if i == self.imageArray.count - 1 {
                self.width = button.right
            }
        }
    }
    
    @objc private func action(button: UIButton) {
        if button.tag - 100 == KeyItemType.bold.rawValue {
            if let boldBtn = self.viewWithTag(KeyItemType.bold.rawValue + 100) as? UIButton {
                boldBtn.isSelected = !boldBtn.isSelected
            }
        }
        
        self.onClick?(KeyItemType.init(rawValue: button.tag - 100)!)
    }
}

