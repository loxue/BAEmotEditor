//
//  ViewController.swift
//  SwiftRichTextDemo
//
//  Created by Steven Xie on 2018/7/23.
//  Copyright © 2018年 Steven Xie. All rights reserved.
//

import UIKit
import WebKit


@available(iOS 8.0, *)
class EditViewController: UIViewController, RichToolsDelegate, UITextViewDelegate {
    
    // 变量初始化
    private var webView: UIWebView?
    private var htmlString = ""
    private var imageArr:Array<Any>?
    
    open var inHtmlString = ""
    private var toolView: RichTools?

    
    // 生命周期方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "发帖"
        
        let save = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(self.saveText))
        navigationItem.rightBarButtonItem = save
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 400))
        webView?.delegate = self
        if let aView = webView {
            view.addSubview(aView)
        }
        let bundle = Bundle.main
        let indexFileURL: URL? = bundle.url(forResource: "richTextEditor", withExtension: "html")
        webView?.keyboardDisplayRequiresUserAction = true
        if let anURL = indexFileURL {
            webView?.loadRequest(URLRequest(url: anURL))
        }
        
        toolView = RichTools(frame: CGRect.init(x: 0, y: 400, width: UIScreen.main.bounds.size.width, height: 50))
        toolView?.backgroundColor = .brown
        
        toolView?.delegate = self
//        toolView?.isShow = true
        toolView?.mainView.mainAction(cellback: { (types ) in
            
        })
//        toolView?.showAction(cellback: { (true) in
//            print("action")
//        })
        
        if let aToolView = toolView {
            view .addSubview(aToolView)
        }
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)
        btn.frame = CGRect(x: UIScreen.main.bounds.size.width - 100, y: UIScreen.main.bounds.size.height - 40, width: 80, height: 30)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("添加图片", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(self.addImage), for: .touchUpInside)
    }
    
    func uploadImageWith(image:UIImage, imagePath:String, imageName:String) {
        let activityIndicator = UIActivityIndicatorView(style:
                                                            UIActivityIndicatorView.Style.gray)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator);
        
        var imageURL = ""
        if image.jpegData(compressionQuality: 0.5) != nil {
            
            activityIndicator.startAnimating()
            
//            doUpdate(imageData:jpegData, success: { (info) in
//                imageURL = info["url"] as! String
                imageURL = "http://og1yl0w9z.bkt.clouddn.com/18-7-25/6373094.jpg"

            
                let url = imageURL
                let script = "window.insertImage('\(url)', '\(imagePath)')"
                
                let dic:Dictionary = ["url": url, "image": image, "name": imageName] as [String : Any]
                self.imageArr?.append(dic)
                
                self.webView?.stringByEvaluatingJavaScript(from: script)
                
                
                activityIndicator.stopAnimating()
//            }, failed: { (error) in
//
//            }, progress: { (progress) in
//
//            })
        }
    }
    
    // MARK: - Method
    func change(_ str: String) -> String? {
        let marr = str.components(separatedBy: "\"")
        
        let newArr = marr.flatMap { htmlString -> [String] in
            var newArr = Array<Any>()
            let aBool = !htmlString.hasPrefix("file:")
            let bBool = !htmlString.hasPrefix(" id")
            if aBool && bBool {
                newArr.append(htmlString)
            }
            return newArr as! [String]
        }
        
        let newStr = newArr.joined(separator: "\"")
        
        return newStr
    }
    
    func string(from date: Date) -> String {
        let dat = Date(timeIntervalSinceNow: 0)
        let a: TimeInterval = dat.timeIntervalSince1970
        let timeString = String(format: "%.0f", a)
        return timeString
    }
    
    func printHTML() {
        let title = webView?.stringByEvaluatingJavaScript(from: "document.getElementById('title-input').value")
        let html = webView?.stringByEvaluatingJavaScript(from: "document.getElementById('content').innerHTML")
        let script = webView?.stringByEvaluatingJavaScript(from: "window.alertHtml()")
        webView?.stringByEvaluatingJavaScript(from: script ?? "")
        print("Title: \(title ?? "")")
        print("Inner HTML: \(html ?? "")")
        if (html?.count ?? 0) == 0 {
            let alert = UIAlertView(title: "提示", message: "请输入内容", delegate: nil, cancelButtonTitle: "不好", otherButtonTitles: "好")
            alert.show()
        } else {
            htmlString = html!
            //对输出的富文本进行处理后上传
            print(change(htmlString)!)
        }
    }
    
    @objc func saveText() {
        printHTML()
    }
    
    @objc func addImage() {
        let imagePickerController = UIImagePickerController()
//        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

//    @objc func keyBoardWillShow(_ node: Notification) {
//        DispatchQueue.main.async {
//            print("键盘唤起了")
//         }
//    }
    
}


extension EditViewController: UIImagePickerControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let now = Date()
        let imageName = "iOS\(string(from: now)).jpg"
        let imagePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(imageName).absoluteString
        let mediaType = info[UIImagePickerController.InfoKey.mediaType.rawValue] as? String
        var image: UIImage?
//        var imageURL = ""
        if (mediaType == "public.image") {
            image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
          
            // 图片压缩方法
//            let imageByte: Int = 400 * 1024
//            let compressImage = EditVC.compressImage(image!, toByte: imageByte)
            
            let imageData = image!.jpegData(compressionQuality: 1)
            do {
                try imageData?.write(to: URL(string: imagePath)!)
            }catch{
            }
            
//            imageURL = uploadImageWith(image: compressImage)
            uploadImageWith(image: image!, imagePath: imagePath, imageName: imageName)
            
        }
        
        dismiss(animated: true)
    }
}

// MARK: -UIWebViewDelegate
extension EditViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if inHtmlString.count > 0 {
            let place = "window.placeHTMLToEditor('\(inHtmlString)')"
            webView.stringByEvaluatingJavaScript(from: place)
        }
    }
}

// MARK: -UINavigationControllerDelegate
extension EditViewController: UINavigationControllerDelegate{
    
    func richText(richTools: RichTools, type: MainView.KeyItemType, beginDidChange textStyle: RichTextStyle) {
        print("beginDidChange")
    }
    
    func richText(richTools: RichTools, type: MainView.KeyItemType, endDidChange textStyle: RichTextStyle) {
        print("endDidChange")
    }
    
    func richText(richTools: RichTools, affineTransform form: CGAffineTransform) {
        print("affineTransform")
    }
}
