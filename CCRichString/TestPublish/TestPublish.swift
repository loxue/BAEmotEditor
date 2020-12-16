//
//  TestPublish.swift
//  CCRichString
//
//  Created by myc on 2020/12/15.
//

import UIKit

let screen_width = UIScreen.main.bounds.size.width // 屏幕宽度
let screen_height = UIScreen.main.bounds.size.height // 屏幕高度
let screen_nav_height: CGFloat = 44 // 导航高度
let screen_statusBar_height = UIApplication.shared.statusBarFrame.size.height // 状态栏高度


class TestPublish: UIViewController {
    
    var richText: RichTextView!
    var richTools: RichTools!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.richTools = RichTools()
        self.richTools.delegate = self
        self.view.addSubview(self.richTools)
        
        self.richText = RichTextView(frame: CGRect(x: 0, y: screen_nav_height, width: screen_width, height: screen_height - screen_nav_height - self.richTools.height), textContainer: nil)
        self.richText.textStyle = self.richTools.textStyle
        self.view.addSubview(self.richText)
    }


    fileprivate func openPhoto(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let vc = UIImagePickerController()
            vc.sourceType = type
            vc.delegate = self
            self.present(vc, animated: true, completion: {
                
            })
        } else {
            
        }
        print(richText.htmlString)
    }
}

extension TestPublish: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            self.openPhoto(type: .photoLibrary)
        } else if buttonIndex == 1 {
            self.openPhoto(type: .camera)
        }
    }
}

extension TestPublish: RichToolsDelegate {
    
    func richText(richTools: RichTools, affineTransform form: CGAffineTransform) {
        let height = screen_height - richTools.height - screen_nav_height
        if form.ty < 0 {
            self.richText.height = height + form.ty
        } else {
            self.richText.height = height
        }
    }
    
    func richText(richTools: RichTools, type: MainView.KeyItemType, beginDidChange textStyle: RichTextStyle) {
        self.richText.textStyle = textStyle
        
        if type == .image {
    
//            let alertView = UIAlertView()
//            alertView.title = "插入图片"
//            alertView.addButton(withTitle: "打开相册")
//            alertView.addButton(withTitle: "打开相机")
//            alertView.cancelButtonIndex = 0
//            alertView.delegate = self
//            alertView.show()
            
            self.openPhoto(type: .photoLibrary)
            
        } else if type == .bold {
            let range = NSRange(location: self.richText.lastSelectedRange.location, length: self.richText.lastSelectedRange.length)
            self.richText.setText(range: range, type: type)
            self.richText.selectedRange = range
        }
    }
    
    func richText(richTools: RichTools, type: MainView.KeyItemType, endDidChange textStyle: RichTextStyle) {
        self.richText.textStyle = textStyle
        
        let range = NSRange(location: self.richText.lastSelectedRange.location, length: self.richText.lastSelectedRange.length)
        
        self.richText.setText(range: range, type: type)
        self.richText.selectedRange = range
    }
    
}

extension TestPublish: UIImagePickerControllerDelegate {
    //选择图片成功后代理
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true) {
            
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            self.richText.setImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
}

extension TestPublish: UINavigationControllerDelegate {
    
}


