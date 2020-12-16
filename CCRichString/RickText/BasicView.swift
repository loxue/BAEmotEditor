//
//  BasicView.swift
//  CCRichString
//
//  Created by myc on 2020/12/16.
//

import UIKit

extension BasicView {
    /// 显示事件
    ///
    /// - Parameter cellback: <#cellback description#>
    public func showAction(cellback: @escaping TouchUpInside) {
        self.onClick = cellback
    }
}


class BasicView: UIView {

    /// 显示状态
    public var isShow: Bool {
        get {
            return self.show
        }
        set {
            self.show = newValue
            self.animate()
        }
    }
    
    private var show = false
    typealias TouchUpInside = (_ isShow: Bool) -> ()
    fileprivate var onClick: TouchUpInside?
    
    convenience init() {
        self.init(frame: CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: RichConfig.height))
        self.isHidden = true
    }

    /// 动画（显示/隐藏）
    ///
    /// - Parameter isShow: 是否显示
    private func animate() {
        if self.isShow {
            UIView.animate(withDuration: 0.3, animations: {
                self.isHidden = false
                self.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.size.width, y: 0)
            }) { (finished) in
                self.onClick?(self.show)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform.identity
                
            }) { (finished) in
                self.isHidden = true
                self.onClick?(self.show)
            }
        }
    }
}

