//
//  FontView.swift
//  CCRichString
//
//  Created by myc on 2020/12/16.
//

import UIKit

class FontView: BasicView {
    
    
    public var getFontSize: CGFloat {
        get {
            return self.fontSize
        }
    }
    
    private var fontSize: CGFloat = 14
    private var show = false
    private var fontArray: [CGFloat] = [16, 18, 22, 26, 30, 36]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        
        self.fontSize = fontArray[0]
        
        for i in 0..<self.fontArray.count {
            let button = UIButton(frame: CGRect(x: CGFloat(i) * RichConfig.fontWidth, y: 0, width: RichConfig.fontWidth, height: self.height))
            button.setTitle(String(format: "%.0f", self.fontArray[i]), for: .normal)
            button.setTitleColor(UIColor.darkText, for: .normal)
            button.setTitleColor(UIColor.orange, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.tag = i + 300
            if self.fontSize == self.fontArray[i] {
                button.isSelected = true
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            }
            button.addTarget(self, action: #selector(FontView.action(button:)), for: .touchUpInside)
            self.addSubview(button)
            if i == self.fontArray.count - 1 {
                self.width = button.right
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func action(button: UIButton) {
        button.isSelected = !button.isSelected
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.fontSize = self.fontArray[button.tag - 300]
        for i in 0..<self.fontArray.count {
            if (i + 300) != button.tag {
                let button = self.viewWithTag(i + 300) as? UIButton
                button?.isSelected = false
                button?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            }
        }
        self.isShow = false
    }
}

