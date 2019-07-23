//
//  OrderViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import UIKit
import WebKit
var isDebug = false;
public class OrderViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    private let FEATURES = "features"
    private let ORDER_PLACE = "order.place"
    private let ALIPAYSCHEME = "alipayScheme"
    private let ALIPAY = "alipay"
    private let ALIPAY_HK = "alipayhk"
    private let SCAN = "scan"
    private let APPLE_PAY = "applepay"
    private let WECHATPAY = "wechatpay"
    private let WECHATPAY_HK = "wechatpayhk"
    private let GPS = "gps"
    private let CARD_IO = "cardIO"
    private let STRIPE_APPLE = "stripeApple"
    private let SHOW_NAVIGATION_BAR = "showNavigationBar";
    private let ISDEBUG = "isDebug";
    private let DISABLE_SCROLL = "disableScroll";
    private let ISBOUNCES = "isBounces";
    private let SYSTEMBROWSERPROTOCOL = "systemOpenUrl";
    private let NAVIGATIONBAR_STYLE = "navigationbarStyle";
    private let CLEAR_CACHE = "clearCache";

    private let ORDER_PLACE_ALIPAY_SDK = "OrderPlaceSdk_Example."
//    private let ORDER_PLACE_ALIPAY_SDK = "OrderPlaceAlipaySDK."

    private let ORDER_PLACE_WECHATPAY_SDK = "OrderPlaceSdk_Example."
//    private let ORDER_PLACE_WECHATPAY_SDK = "OrderPlaceWechatPaySDK."

    private let ORDER_PLACE_CARD_IO_SDK = "OrderPlaceSdk_Example.";
//    private let ORDER_PLACE_CARD_IO_SDK = "OrderPlaceCardIOSDK.";

    private let ORDER_PLACE_STRIPE_APPLE_SDK = "OrderPlaceSdk_Example.";
//        private let ORDER_PLACE_STRIPE_APPLE_SDK = "OrderPlaceStripeAppleSDK.";

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewContainer: UIView!
    var webView: WKWebView!;
    var url: String!;
    var options: [String: Any]!;

    var closeCB: ((Any?) -> Void)? = nil
    private var showNavigationBar: Bool = false;
    private var disableScroll: Bool = true;
    private var isBounces: Bool = false;

    var serciceMap: [String: OrderPlaceService] = [:]
    var extraServices: Array<OrderPlaceService>!;
    var systemBrowserProtocols: [String] = [];
    var navigationbarStyle = [String: Any]();
    let originStatusBarStyle = UIApplication.shared.statusBarStyle;
//    var originStaBarBackground: UIColor? = nil;
    
    var _clearCache = true;
    public required init?(coder aDecoder: NSCoder) {
        JJPrint("init coder style2")
        super.init(coder: aDecoder)
    }

    @IBAction func exitClicked(_ sender: Any) {
        JJPrint("exit clicked2")
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true)
        self.serciceMap.removeAll()
    }

    deinit {
        JJPrint("order view controller deinit")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if self.options != nil, let showNavBar = self.options![SHOW_NAVIGATION_BAR] as? Bool {
            showNavigationBar = showNavBar
        }

        if self.options != nil, let disableScroll = self.options![DISABLE_SCROLL] as? Bool {
            self.disableScroll = disableScroll
        }
        if self.options != nil, let bounces = self.options![ISBOUNCES] as? Bool {
            self.isBounces = bounces
        }
        if self.options != nil, let systemBrowserProtocols = self.options![SYSTEMBROWSERPROTOCOL] as? [String] {
            self.systemBrowserProtocols = systemBrowserProtocols;
        }
        
        if self.options != nil, let cache = self.options![CLEAR_CACHE] as? Bool {
            self._clearCache = cache;
        }
        
        if self.options != nil, let isdebug = self.options![ISDEBUG] as? Bool {
            isDebug = isdebug
        }
        if (navigationController != nil) {
            navigationController?.delegate = self;
        }
        automaticallyAdjustsScrollViewInsets = false

        
        if self._clearCache {
            self.clearCache();
        }
        
        JJPrint("OrderViewController viewDidLoad2")
        JJPrint("options:\(self.options)")

        let webConfiguration = WKWebViewConfiguration()

        let userContentController = WKUserContentController()

        let configService = ConfigService()
        configService.options = self.options;
        configService.closeCB = closeCB;
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

        settingScroll();

        JJPrint(customFrame)

        self.viewContainer.addSubview(webView)
        self.viewContainer.insertSubview(activityIndicator, aboveSubview: webView)


        if(self.url != nil) {
            let myURL = URL(string: url)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
            JJPrint("loading url")
        } else {
            showNavigationBar = true;
            stopIndicator()
        }

    }
    
    private func clearCache() {
        if #available(iOS 9.0, *) {
            /*
             在磁盘缓存上。
             WKWebsiteDataTypeDiskCache,
             html离线Web应用程序缓存。
             WKWebsiteDataTypeOfflineWebApplicationCache,
             内存缓存。
             WKWebsiteDataTypeMemoryCache,
             本地存储。
             WKWebsiteDataTypeLocalStorage,
             Cookies
             WKWebsiteDataTypeCookies,
             会话存储
             WKWebsiteDataTypeSessionStorage,
             IndexedDB数据库。
             WKWebsiteDataTypeIndexedDBDatabases,
             查询数据库。
             WKWebsiteDataTypeWebSQLDatabases
             */
            let types = [WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache]
            let websiteDataTypes = Set<AnyHashable>(types)
            let dateFrom = Date(timeIntervalSince1970: 0)
            if let websiteDataTypes = websiteDataTypes as? Set<String> {
                WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom, completionHandler: {
                    JJPrint("removeData completionHandler");
                })
            }
        } else {
//            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
//            let cookiesFolderPath = libraryPath + ("/Cookies")
//            JJPrint("\(cookiesFolderPath)")
//            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
        }
    }

    private func settingScroll() {
        // isScrollEnabled 與 bounces 最好不要同時set false
        //        webView.scrollView.isScrollEnabled = false;

        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }

        webView.scrollView.bounces = self.isBounces;

        if disableScroll {
            webView.scrollView.isScrollEnabled = false;
            webView.scrollView.delegate = self;
        } else {
            webView.scrollView.isScrollEnabled = true;
            webView.scrollView.delegate = nil;
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

        case ALIPAY_HK:
            fallthrough
        case ALIPAY:
            let alipayService = AlipayService(options)
            // 最后要保持名字为 framework 的名字
            if let delegate = NSClassFromString(ORDER_PLACE_ALIPAY_SDK + "AlipayExecutor") as? NSObject.Type {
                alipayService.alipayDelegate = delegate.init() as? AlipayDelegate
            }
            JJPrint("jadd AlipayService.SERVICE_NAME:\(AlipayService.SERVICE_NAME)");
            return alipayService
        case SCAN:
            return ScannerService(options);
        case WECHATPAY_HK:
            fallthrough
        case WECHATPAY:
            var wechat = WechatPayService(options);
            if let delegate = NSClassFromString(ORDER_PLACE_WECHATPAY_SDK + "WechatExecutor") as? NSObject.Type {
                wechat = WechatPayService(options, delegate.init() as? WeChatPayDelegate)
            }
            return wechat
        case APPLE_PAY:
            return ApplepayService(options);
        case CARD_IO:
            var cardIOService = CardIOService();
            if let delegate = NSClassFromString(ORDER_PLACE_CARD_IO_SDK + "CardIOExecutor") as? NSObject.Type {
                cardIOService = CardIOService(delegate.init() as? cardIODelegate)
            }
            return cardIOService;
        case STRIPE_APPLE:
            var stripeAppleService: StripeAppleService;
            if let delegate = NSClassFromString(ORDER_PLACE_STRIPE_APPLE_SDK + "StripeExecutor") as? NSObject.Type {
                stripeAppleService = StripeAppleService(options, delegate.init() as? StripeAppleDelegate)
            } else {
                stripeAppleService = StripeAppleService(options);
            }
            return stripeAppleService;
        default:
            break;
        }

        return nil;

    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        JJPrint("url: navigationAction...\(navigationAction.request.url?.absoluteString)")
        if let url = navigationAction.request.url?.absoluteString {

            var isSystemOpen = false;
            var URL_S: URL!
            if let Url = URL(string: url) {
                URL_S = Url;
                if systemBrowserProtocols.count > 0 {
                    systemBrowserProtocols.forEach { (systemUrl) in
                        if (url.starts(with: systemUrl)) {
                            isSystemOpen = UIApplication.shared.canOpenURL(Url) ;
                            return;
                        }
                    }
                }
            }

            if let alipayService = self.serciceMap[AlipayService.SERVICE_NAME] as? AlipayService, self.options != nil, let features = self.options[FEATURES] as? String, features.contains(ALIPAY), let del = alipayService.alipayDelegate, let options = self.options, let alipayScheme = options[ALIPAYSCHEME] as? String {
                del.AliapyWebView = webView
                let legalOrderInfo = del.AlipayFetchOrderInfo(url: url, alipayScheme: alipayScheme)
                if legalOrderInfo {
                    decisionHandler(WKNavigationActionPolicy.cancel)
                    return;
                } else if isSystemOpen {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL_S, options: [:], completionHandler: nil);
                    } else {
                        UIApplication.shared.openURL(URL_S)
                    }
                    decisionHandler(WKNavigationActionPolicy.cancel)
                    return;
                }
            } else if isSystemOpen {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL_S, options: [:], completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(URL_S)
                }
                decisionHandler(WKNavigationActionPolicy.cancel)
                return;
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)


    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        JJPrint("didCommit url:-- \(webView.url?.absoluteString)")
        if let host = webView.url?.host, host.contains(ORDER_PLACE) {
            //setNavigationBar(hidden: true)

            setNavigationBar(hidden: !showNavigationBar)

        } else {
//            setNavigationBar(hidden: false)
            setNavigationBar(hidden: !showNavigationBar)
        }
        startIndicator()
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        JJPrint("finish url:\(webView.url?.absoluteString)")
        stopIndicator()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        JJPrint("didFail url:\(webView.url?.absoluteString)--\(error)")
        setNavigationBar(hidden: false)
        stopIndicator()
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

//        JJPrint("didFailProvisionalNavigation:\(webView.url) --:\(error)")
        showAlert(title: "Error", message: error.localizedDescription, OKHandler: nil)
        setNavigationBar(hidden: false)
        stopIndicator()
    }



    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        JJPrint("message:\(message.body)")

        /*
         if("ConfigService" == message.name){
         
         self.configService.handleMessage(method: "back", body: message.body, callback: nil);
         
         }*/

        JJPrint("jadd AlipayService.SERVICE_NAME:\(AlipayService.SERVICE_NAME)");
        JJPrint("jadd self.serciceMap:\(self.serciceMap)");

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
            JJPrint("service not registered", serviceName)
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

    public func closeKeyboard() {
        webView.endEditing(true);
    }
    private func getFont(index:Int,size:CGFloat = 18.0) -> UIFont?{
        switch index {
        case 0:
            return UIFont.systemFont(ofSize: size);
        case 1:
            return UIFont.boldSystemFont(ofSize: size);
        case 2:
            return UIFont.italicSystemFont(ofSize: size);
        default:
            return nil;
        }
    }
    private func getBackImage() -> UIImage?{
        let podBundle = Bundle(for: OrderPlace.self)
//        [UIImage imageNamed:@"imageView" inBundle:[NSBundle bundleForClass:self.class]
        let image = UIImage(named: "back", in: podBundle, compatibleWith: nil);
        print("getBackImage:\(image)")
        return image;
    }
    
    private func getBackImageWithPath(path:String) -> UIImage? {
        let image = UIImage(contentsOfFile: path);
        return image;
    }

    private func setNavigationBarStyle() {
        
        var titleFontStyle = [String: Any]();
        var backFontStyle = [String: Any]();
        var titleFont = 0;
        var titleSize : CGFloat = 18.0;
        var backFont = 0;
        var backSize : CGFloat = 18.0;
        

        if self.options != nil, let navigationbarStyle = self.options[NAVIGATIONBAR_STYLE] as? [String: Any] {
            self.navigationbarStyle = navigationbarStyle;
        }
        
        if self.options != nil, let tmpTitleFontStyle = self.navigationbarStyle["titleFontStyle"] as? [String: Any] {
            titleFontStyle = tmpTitleFontStyle;
        }
        if self.options != nil, let tmpBackFontStyle = self.navigationbarStyle["backFontStyle"] as? [String: Any] {
            backFontStyle = tmpBackFontStyle;
        }
        if let font = titleFontStyle["font"] as? Int {
            titleFont = font;
        }
        if let size = titleFontStyle["size"] as? Int {
            titleSize = CGFloat(size);
        }
        if let font = backFontStyle["font"] as? Int {
            backFont = font;
        }
        if let size = backFontStyle["size"] as? Int {
            backSize = CGFloat(size);
        }
        var textDic : [NSAttributedStringKey : Any] = [:];
        if let font = getFont(index: backFont, size: backSize) {
            textDic[NSAttributedStringKey.font] = font;
        }
        if let textColS = self.navigationbarStyle["textColor"] as? String, let textColor = UIColor.getHex(hex: textColS) {
            textDic[NSAttributedStringKey.foregroundColor] = textColor;
        }
        if let backText = self.navigationbarStyle["backText"] as? String {
//            self.navigationController?.navigationItem.leftBarButtonItem?.title = backText;
            let leftBtn = UIBarButtonItem(title: backText, style: .plain, target: self, action: #selector(exitClicked));
            leftBtn.setTitleTextAttributes(textDic, for: .normal);
            navigationItem.setLeftBarButton(leftBtn, animated: false)
        } else if let backArrow = self.navigationbarStyle["backArrow"] as? Bool {
            if (backArrow) {
                var image:UIImage? = nil;
                if let imagePath = self.navigationbarStyle["backImagePath"] as? String {
                    image = UIImage(contentsOfFile: imagePath);
                } else {
                    image = getBackImage()
                }
                
                if image != nil {
                    navigationItem.setLeftBarButton(nil, animated: false);
                    let leftbtn = UIButton(type: .custom);
                    leftbtn.bounds = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height);
                    leftbtn.setImage(image, for: .normal);
                    leftbtn.contentHorizontalAlignment = .left;
                    leftbtn.contentVerticalAlignment = .center;
                    leftbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -((image!.size.width) * 0.5 - 2), 0, 0);
                    leftbtn.addTarget(self, action: #selector(exitClicked), for: .touchUpInside);
                    let leftBarbtn = UIBarButtonItem(customView: leftbtn);
                    leftbtn.alpha = 1.0;
                    leftbtn.isHidden = false;
                    navigationItem.setLeftBarButton(leftBarbtn, animated: false)
                }
                
            }
        }
        if let backgroundColorHex = self.navigationbarStyle["backgroundColor"] as? String, let backgroundColor = UIColor.getHex(hex: backgroundColorHex) {
            self.navigationController?.navigationBar.barTintColor = backgroundColor;
        }

        if let title = self.navigationbarStyle["title"] as? String {
            let width = UIScreen.main.bounds.width;
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: width*0.7, height: 22))
            label.backgroundColor = UIColor.clear
            label.font = UIFont.systemFont(ofSize: 18.0)
            label.textAlignment = .center
            label.textColor = UIColor.blue
            navigationItem.titleView = label
            label.text = title
            label.numberOfLines = 1;
            label.lineBreakMode = .byWordWrapping;
            //JJPrint("size:\(label.frame) -:\(width*0.7)")
            if let textColS = self.navigationbarStyle["textColor"] as? String, let textColor = UIColor.getHex(hex: textColS) {
                label.textColor = textColor;
            }
            if let font = getFont(index: titleFont, size: titleSize) {
                label.font = font;
            }
            
        }

        if let statusBarStyle = self.navigationbarStyle["statusBarStyle"] as? Int {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle(rawValue: statusBarStyle) ?? originStatusBarStyle;
        }
        
        if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? NSObject, let statusbar = statusBarWindow.value(forKey: "statusBar") as? UIView {
            if statusbar.responds(to: #selector(setter: UIView.backgroundColor)) {
//                self.originStaBarBackground = statusbar.backgroundColor;
                if let backgroundColorHex = self.navigationbarStyle["statusbarBackgroundColor"] as? String, let backgroundColor = UIColor.getHex(hex: backgroundColorHex) {
                    statusbar.backgroundColor = backgroundColor;
                }
            }
        }


    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        setNavigationBarStyle();
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
//        setNavigationBarStyle();
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        UIApplication.shared.statusBarStyle = originStatusBarStyle;
        if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? NSObject, let statusbar = statusBarWindow.value(forKey: "statusBar") as? UIView {
            if statusbar.responds(to: #selector(setter: UIView.backgroundColor)) {
//                statusbar.backgroundColor = self.originStaBarBackground;
                statusbar.backgroundColor = .clear;
            }
        }
    }
}

extension OrderViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isHidden = viewController.isKind(of: OrderViewController.self) && !showNavigationBar
        //JJPrint("viewController: \(viewController) \(isHidden)")
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }
}

extension OrderViewController: ScannerDelegate {
    public func scannerApplicationOpenUrl(_ app: UIApplication, url: URL) {
        applicationOpenUrl(app, url: url)
    }
}

extension OrderViewController {
    public func showAlert(title: String?, message: String?, OKHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: OKHandler));
        present(alertController, animated: true, completion: nil)
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

//        if let wechatPayService = self.serciceMap[WechatPayService.SERVICE_NAME] as? WechatPayService, self.options != nil, let features = self.options["features"] as? String, features.contains("wechatpay") {
//            let wxapiManager = WXApiManager.sharedManager
//            wxapiManager.payResultCallback = wechatPayService.payResultCallback
//            WXApi.handleOpen(url, delegate: wxapiManager)
//
//        }

    }

}

extension OrderViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView...");
        scrollView.contentOffset = CGPoint.zero;
    }
}
public func JJPrint<T>(_ message: T, file: String = #file, _ func: String = #function, _ lineNumber: Int = #line) {

    guard isDebug else { return }
    let file = (file as NSString).lastPathComponent;
    print("File:\(file):(\(lineNumber))-- \(message)");

}


extension UIColor {
    static func getHex(hex: String) -> UIColor? {
        guard !hex.isEmpty && hex.hasPrefix("#") else { return nil }
        var rgbValue: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        guard scanner.scanHexInt32(&rgbValue) else { return nil }
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
            blue: CGFloat((rgbValue & 0xFF)) / 255.0,
            alpha: 1);
    }
}
