//
//  CloseButton.swift
//  CCRichString
//
//  Created by myc on 2020/12/16.
//

import UIKit

extension CloseBtn {
    
    public func close(cellback: @escaping TouchUpInside) {
        self.onClick = cellback
    }
}

class CloseBtn: UIButton {
    
    enum BtnType {
        case close
        case editing
    }
    
    var type: BtnType {
        get {
            if self.imageView?.image == self.closeIcon {
                return .close
            }
            return .editing
        }
        set {
            switch newValue {
            case .close:
                self.setImage(self.closeIcon, for: .normal)
            case .editing:
                self.setImage(self.keyBoardIcon, for: .normal)
            }
        }
    }
    
    var getWidth: CGFloat {
        get {
            return RichConfig.closeWidth
        }
    }
    
    private let closeIcon = UIImage(named: "IconSource.bundle/icon_close")
    private let keyBoardIcon = UIImage(named: "IconSource.bundle/icon_keyBoard")
    
    fileprivate var onClick: TouchUpInside?
    typealias TouchUpInside = () -> ()
    private var show = false
    
    convenience init() {
        self.init(frame: CGRect(x: UIScreen.main.bounds.size.width - RichConfig.closeWidth, y: 0, width: RichConfig.closeWidth, height: RichConfig.height))

        self.addTarget(self, action: #selector(CloseBtn.switchAction), for: .touchUpInside)
        
        self.setImage(self.keyBoardIcon, for: .normal)
    }

    /// 隐藏键盘
    @objc private func switchAction() {
        switch type {
        case .close:
            self.onClick?()
        case .editing:
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }
}

