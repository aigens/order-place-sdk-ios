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

    private let FEATURES = "features"
    private let ORDER_PLACE = "order.place"
    private let ALIPAYSCHEME = "alipayScheme"
    private let ALIPAY = "alipay"
    private let SCAN = "scan"
    private let APPLE_PAY = "applepay"
    private let WECHATPAY = "wechatpay"
    private let GPS = "gps"

    private let ORDER_PLACE_ALIPAY_SDK = "OrderPlaceSdk_Example."
//    private let ORDER_PLACE_ALIPAY_SDK = "OrderPlaceAlipaySDK."

    private let ORDER_PLACE_WECHATPAY_SDK = "OrderPlaceSdk_Example."
//    private let ORDER_PLACE_WECHATPAY_SDK = "OrderPlaceWechatPaySDK."

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewContainer: UIView!
    var webView: WKWebView!;
    var url: String!;
    var options: [String: Any]!;
    private var showNavigationBar: Bool = false;

    var serciceMap: [String: OrderPlaceService] = [:]
    var extraServices: Array<OrderPlaceService>!;

    public required init?(coder aDecoder: NSCoder) {
        print("init coder style2")
        super.init(coder: aDecoder)
    }

    @IBAction func exitClicked(_ sender: Any) {
        print("exit clicked2")
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true)
        self.serciceMap.removeAll()
    }

    deinit {
        print("order view controller deinit")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if (navigationController != nil) {
            navigationController?.delegate = self;
        }
        automaticallyAdjustsScrollViewInsets = false

        debugPrint("OrderViewController viewDidLoad2")
        debugPrint("options: ", self.options)

        let webConfiguration = WKWebViewConfiguration()

        let userContentController = WKUserContentController()

        let configService = ConfigService()
        configService.options = self.options;
        configService.clickedExit = { [weak self] in
            self?.serciceMap.removeAll()
        }
        self.addService(service: configService, controller: userContentController)

        self.addFeatures(controller: userContentController)

        if(self.extraServices != nil) {
            for service in self.extraServices {
                self.addService(service: service, controller: userContentController)
            }
        }


        webConfiguration.userContentController = userContentController
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.viewContainer.frame.size.width, height: self.viewContainer.frame.size.height))
        self.webView = WKWebView (frame: customFrame, configuration: webConfiguration)
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.navigationDelegate = self;

        print(customFrame)

        self.viewContainer.addSubview(webView)
        self.viewContainer.insertSubview(activityIndicator, aboveSubview: webView)


        if(self.url != nil) {
            let myURL = URL(string: url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
            print("loading url")
        } else {
            showNavigationBar = true;
            stopIndicator()
        }

    }

    func addService(service: OrderPlaceService, controller: WKUserContentController) {
        let serviceName = service.getServiceName();
        self.serciceMap[serviceName] = service;
        service.vc = self;
        service.initialize()
        //controller.add(self, name: serviceName)

        controller.add(WKScriptMsgHandler(scriptDelegate: self), name: serviceName)
    }

    func addFeatures(controller: WKUserContentController) {

        if(self.options == nil) {
            return;
        }

        let features = self.options[FEATURES] as? String;

        if(features == nil) {
            return;
        }

        let fs = features!.split(separator: ",")

        for f in fs {

            let service = self.makeService(feature: String(f))
            if(service != nil) {
                self.addService(service: service!, controller: controller)
            }

        }

    }

    func makeService(feature: String) -> OrderPlaceService! {

        switch(feature) {

        case GPS:
            return GpsService()

        case ALIPAY:
            let alipayService = AlipayService(options)
            // 最后要保持名字为 framework 的名字
            if let delegate = NSClassFromString(ORDER_PLACE_ALIPAY_SDK + "AlipayExecutor") as? NSObject.Type {
                alipayService.alipayDelegate = delegate.init() as? AlipayDelegate
            }
            return alipayService
        case SCAN:
            return ScannerService(options);
        case WECHATPAY:
            var wechat = WechatPayService();
            if let delegate = NSClassFromString(ORDER_PLACE_WECHATPAY_SDK + "WechatExecutor") as? NSObject.Type {
                wechat = WechatPayService(delegate.init() as? WeChatPayDelegate)
            }
            return wechat
        case APPLE_PAY:
            return ApplepayService(options);
        default:
            break;
        }

        return nil;

    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = webView.url?.absoluteString {

            if let alipayService = self.serciceMap[AlipayService.SERVICE_NAME] as? AlipayService, self.options != nil, let features = self.options[FEATURES] as? String, features.contains(ALIPAY), let del = alipayService.alipayDelegate, let options = self.options, let alipayScheme = options[ALIPAYSCHEME] as? String {
                del.AliapyWebView = webView
                let legalOrderInfo = del.AlipayFetchOrderInfo(url: url, alipayScheme: alipayScheme)
                if legalOrderInfo {
                    decisionHandler(WKNavigationActionPolicy.cancel)
                } else {
                    decisionHandler(WKNavigationActionPolicy.allow)
                }
            } else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }


    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //print("didCommit url:-- \(webView.url?.host)")
        if let host = webView.url?.host, host.contains(ORDER_PLACE) {
            setNavigationBar(hidden: true)
        } else {
            setNavigationBar(hidden: false)
        }
        startIndicator()
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("finish url:\(webView.url?.absoluteString)")
        stopIndicator()
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //print("didFail url:\(webView.url?.absoluteString)")
        setNavigationBar(hidden: false)
        stopIndicator()
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        print("message", message.body)

        /*
         if("ConfigService" == message.name){
         
         self.configService.handleMessage(method: "back", body: message.body, callback: nil);
         
         }*/
        let serviceName = message.name;
        let service = self.serciceMap[serviceName];
        if(service != nil) {
            let body = message.body as! NSDictionary;
            let method = body["_method"] as! String;
            let handler = CallbackHandler()
            let callback = body["_callback"] as? String;
            handler.callback = callback;
            handler.webView = webView;
            handler.cc = userContentController;
            service?.handleMessage(method: method, body: body, callback: handler)
        } else {
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

    private func setNavigationBar(hidden: Bool) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: false)
    }
    private func startIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func stopIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }


}
extension OrderViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isHidden = viewController.isKind(of: OrderViewController.self) && !showNavigationBar
        //print("viewController: \(viewController) \(isHidden)")
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }
}

extension OrderViewController: OrderPlaceDelegate {
    func applicationOpenUrl(_ app: UIApplication, url: URL) {

        // for alipay  host
        if let alipayService = self.serciceMap[AlipayService.SERVICE_NAME] as? AlipayService, self.options != nil, let features = self.options[FEATURES] as? String, features.contains(ALIPAY) {

            if let del = alipayService.alipayDelegate {
                del.AlipayApplicationOpenUrl(app, url: url)
            }

        }

        if let wechatPayService = self.serciceMap[WechatPayService.SERVICE_NAME] as? WechatPayService, self.options != nil, let features = self.options[FEATURES] as? String, features.contains(WECHATPAY) {

            if let del = wechatPayService.weChatPayDelegate {
                del.wechatApplicationOpenUrl(app, url: url)
            }

        }

        if let wechatPayService = self.serciceMap[WechatPayService.SERVICE_NAME] as? WechatPayService, self.options != nil, let features = self.options["features"] as? String, features.contains("wechatpay") {
            let wxapiManager = WXApiManager.sharedManager
            wxapiManager.payResultCallback = wechatPayService.payResultCallback
            WXApi.handleOpen(url, delegate: wxapiManager)

        }

    }

}



