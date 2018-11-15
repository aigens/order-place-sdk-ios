//
//  OrderViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import UIKit
import WebKit
import ENETSLib
public class OrderViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    private let GPSFEATURE: String = "gps"
    private let NETSPAYFEATURE: String = "netspay"
    private let ALIPAYFEATUR: String = "alipay"
    private let SCANFEATUR: String = "scan"



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
    }


    public override func viewDidLoad() {
        super.viewDidLoad()

        if (navigationController != nil) {
            navigationController?.delegate = self;
        }
        automaticallyAdjustsScrollViewInsets = false

        print("OrderViewController viewDidLoad2")
        print("options", self.options)

        let webConfiguration = WKWebViewConfiguration()

        let userContentController = WKUserContentController()

        let configService = ConfigService()
        configService.options = self.options;
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

        controller.add(self, name: serviceName)
    }

    func addFeatures(controller: WKUserContentController) {

        if(self.options == nil) {
            return;
        }

        let features = self.options["features"] as? String;

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

        case GPSFEATURE:
            return GpsService()
        case NETSPAYFEATURE:
            return NetsPayService(options);
        case ALIPAYFEATUR:
            return AlipayService(options);
        case SCANFEATUR:
            return ScannerService(options);
        default:
            break;
        }

        return nil;

    }
    private func loadWithUrlStr(urlStr: String) {
        print("urlStr url:\(urlStr)");
        guard let url = URL(string: urlStr) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let webRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30.0)
            self.webView.load(webRequest)
        }
    }

    private func payWithUrlOrder(urlOrder: String) {

        AlipaySDK.defaultService().payUrlOrder(urlOrder, fromScheme: AlipayService.appScheme) { [weak self](dict) in
            print("payWithUrlOrder dict:\(dict)")
            guard let dictResult = dict else { return }
            if let isProcessUrlPay = dictResult[AnyHashable("isProcessUrlPay")] as? String, let urlStr = dictResult[AnyHashable("returnUrl")] as? String {
                if isProcessUrlPay == "1" {
                    self?.loadWithUrlStr(urlStr: urlStr)
                }
            }
        }

    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = webView.url?.absoluteString {
            let orderInfo = AlipaySDK.defaultService().fetchOrderInfo(fromH5PayUrl: url)
            if orderInfo != nil, orderInfo!.count > 0 {
                self.payWithUrlOrder(urlOrder: orderInfo!)
                decisionHandler(WKNavigationActionPolicy.cancel)
            } else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }

        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //print("didCommit url:-- \(webView.url?.host)")
        if let host = webView.url?.host, host.contains("order.place") {
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
        if let alipayService = self.serciceMap[AlipayService.SERVICE_NAME] as? AlipayService, self.options != nil, let features = self.options["features"] as? String, features.contains(ALIPAYFEATUR) {
            // wallet pay
            // if SDK is not available, will open alipay APP to pay, then need to pass the payment result back //to development kit
            if url.host == "safepay" {

                //The merchant’s APP may be killed by the system while processing payment in alipay APP, //then the callback will fail. Please handle the return result of standbyCallback.
                AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDict) in
                    print("wallet pay callback result:\(resultDict)")
                    alipayService.payResultCallback?.success(response: resultDict)
                })

                // 授权跳转支付宝钱包进行支付，处理支付结果
                AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDict) in
                    print("processAuth_V2Result result:\(resultDict)")
                    if let dictResult = resultDict, let result = dictResult["result"] as? String {
                        print("processAuth_V2 Result result ->:\(result)")
                    }

                })

            } else if url.host == "platformapi" { //Alipay wallet express login authorization returns authCode
                AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (resultDict) in
                    //The merchant’s APP may be killed by the system while processing payment in alipay //APP, then the callback will fail. Please handle the return result of standbyCallback.
                    print("wallet pay callback result:\(resultDict)")
                    alipayService.payResultCallback?.success(response: resultDict)
                })

                // 授权跳转支付宝钱包进行支付，处理支付结果
                AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDict) in
                    print("processAuth_V2Result result:\(resultDict)")
                    if let dictResult = resultDict, let result = dictResult["result"] as? String {
                        print("processAuth_V2 Result result ->:\(result)")
                    }

                })

            }
        }


        /// netspay
        if self.options != nil, let features = self.options["features"] as? String, features.contains(NETSPAYFEATURE), let appDelegate = app.delegate {
            _ = PaymentRequestManager.handleOpenURL(appDelegate: appDelegate, url: url)
        }


    }

}



