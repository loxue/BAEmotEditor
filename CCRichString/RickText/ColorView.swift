//
//  ColorView.swift
//  CCRichString
//
//  Created by myc on 2020/12/16.
//

import UIKit


class ColorView: BasicView {

    /// 获取当前颜色
    public var getColor: UIColor {
        get {
            return self.color
        }
    }
    
    private var show = false
    private var color: UIColor! // 当前选中颜色
    private var colorArray = [Tools.shared.checkColor(code: "#000000"),
                              Tools.shared.checkColor(code: "#666666"),
                              Tools.shared.checkColor(code: "#999999"),
                              Tools.shared.checkColor(code: "#ff4d3b"),
                              Tools.shared.checkColor(code: "#973bff"),
                              Tools.shared.checkColor(code: "#3b7cff"),
                              Tools.shared.checkColor(code: "#00b2ec"),
                              Tools.shared.checkColor(code: "#2fc95a"),
                              Tools.shared.checkColor(code: "#ff9000"),
                              Tools.shared.checkColor(code: "#ff4200"),
                              Tools.shared.checkColor(code: "#661a00")]


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        
        self.color = self.colorArray[0]
        
        let size: CGFloat = self.height - 10
        for color in self.colorArray {
            let i = self.colorArray.index(of: color)!
            let left = 10 + (size + 10) * CGFloat(i)
            let button = UIButton(frame: CGRect(x: left, y: 5, width: size, height: size))
            button.backgroundColor = color
            if self.getColor == color {
                button.isSelected = true
            }
            button.layer.cornerRadius = button.height / 2
            button.setImage(UIImage(named: "IconSource.bundle/icon_seleColor"), for: .selected)
            button.setImage(nil, for: .normal)
            button.tag = i + 200
            button.imageView?.contentMode = .scaleAspectFill
            button.addTarget(self, action: #selector(ColorView.selectAction(button:)), for: .touchUpInside)
            self.addSubview(button)
            if i == self.colorArray.count - 1 {
                self.width = button.right + 10
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 颜色选择
    ///
    /// - Parameter button: 颜色按钮
    @objc private func selectAction(button: UIButton) {
        button.isSelected = !button.isSelected
        for i in 0..<self.colorArray.count {
            let view = self.viewWithTag(i + 200) as? UIButton
            if (i + 200) != button.tag {
                view?.isSelected = false
            }
        }
        self.color = self.colorArray[button.tag - 200]
        self.isShow = false
    }

    
}

