//
//  OrderViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import UIKit
import WebKit

public class OrderViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var viewContainer: UIView!
    var webView: WKWebView!;
    var url: String!;
    var features: String!;
    
    var serciceMap: [String: OrderPlaceService] = [:]
    var extraServices: Array<OrderPlaceService>!;
    
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
        
        let userContentController = WKUserContentController()
        
        //self.configService = ConfigService()
        //userContentController.add(self, name: "ConfigService")
        self.addService(service: ConfigService(), controller: userContentController)
        
        self.addFeatures(controller: userContentController)
        
        if(self.extraServices != nil){
            for service in self.extraServices{
                self.addService(service: service, controller: userContentController)
            }
        }
        
        
        
        webConfiguration.userContentController = userContentController
        
        
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
    
    func addService(service: OrderPlaceService, controller: WKUserContentController){
        let serviceName = service.getServiceName();
        self.serciceMap[serviceName] = service;
        service.vc = self;
        
        service.initialize()
        
        controller.add(self, name: serviceName)
    }
    
    func addFeatures(controller: WKUserContentController){
        
        let fs = self.features.split(separator: ",")
        
        for f in fs{
            
            let service = self.makeService(feature: String(f))
            if(service != nil){
                self.addService(service: service!, controller: controller)
            }
            
        }
        
        
    }
    
    func makeService(feature: String) -> OrderPlaceService!{
        
        switch(feature){
            
            case "gps":
                return GpsService()
            
            default:
                break;
        }
        
        return nil;
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("finish url");
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("message", message.body)
        
        /*
        if("ConfigService" == message.name){
            
            self.configService.handleMessage(method: "back", body: message.body, callback: nil);
            
        }*/
        let serviceName = message.name;
        let service = self.serciceMap[serviceName];
        if(service != nil){
            let body = message.body as! NSDictionary;
            let method = body["_method"] as! String;
            let handler = CallbackHandler()
            let callback = body["_callback"] as? String;
            handler.callback = callback;
            handler.webView = webView;
            handler.cc = userContentController;
            service?.handleMessage(method: method, body: body, callback: handler)
        }else{
            print("service not registered", serviceName)
        }
        
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .actionSheet)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
