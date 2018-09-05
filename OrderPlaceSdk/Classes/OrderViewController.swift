//
//  OrderViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import UIKit
import WebKit

public class OrderViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var viewContainer: UIView!
    var webView: WKWebView!;
    var url: String!;
   
    public required init?(coder aDecoder: NSCoder) {
        print("init coder style")
        super.init(coder: aDecoder)
       
    }
    
    @IBAction func exitClicked(_ sender: Any) {
    
        print("exit clicked2")
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true)
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("OrderViewController viewDidLoad")
        
        
        let webConfiguration = WKWebViewConfiguration()
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.viewContainer.frame.size.width, height: self.viewContainer.frame.size.height))
        self.webView = WKWebView (frame: customFrame , configuration: webConfiguration)
        
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        print(customFrame)
        
        self.viewContainer.addSubview(webView)
       
        
        webView.uiDelegate = self
        webView.navigationDelegate = self;
        
        if(self.url != nil){
            let myURL = URL(string:url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
            print("loading url")
        }
        
 
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("finish url");
    }
}
