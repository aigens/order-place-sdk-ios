//
//  ViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 09/02/2018.
//  Copyright (c) 2018 Peter Liu. All rights reserved.
//

import UIKit

// set params docs: https://docs.google.com/document/d/1YkTXzsdmWD7Q8BgLVWlekI6nyiS1wcU2Y6T2aHUKiJw/edit?usp=sharing

/**  params
 features:[String:String]
 {
 gps,
 scan,
 wechatpayhk,
 alipayhk,
 applepay,
 cardIO,
 stripeApple
 
 }

 alipayScheme:String
 appleMerchantIdentifier:String
 member:[String:Any]
 stripePublishableKey:String
 showNavigationBar:Bool
 isDebug:Bool
 
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let infoDictionary = Bundle.main.infoDictionary,let executableFile = infoDictionary[kCFBundleExecutableKey as String] {
            print("executableFile:\(executableFile)") //获取项目名称
        }
        
        
    }
    
    private func forLPTest() {
        let url = "https://test.order.place/#/court-store-list/5175539845300224";
//        let url = "http://192.168.0.253:8100/#/court-store-list/5175539845300224";
//        let url = "http://localhost:8100/#/store/102945/mode/takeaway";
        
        var member = [String: Any]()
        
        member["memberId"] = "123456"
        member["session"] = "ABCDEF" //same as session
        member["source"] = "lp"
        member["language"] = "zh" //en,zh,zh-cn
        member["name"] = "Optional Name" //Optional (with actual data)
        member["gender"] = "M" //Optional (with actual data)
        member["age"] = 25 //Optional (with actual data)
        member["phone"] = "65448231" //Optional (with actual data)
        member["email"] = "peter.liu@gmail.com" //Optional (with actual data)
        let options = ["features": "gps,scan,alipayhk,applepay,wechatpay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.aigens.test","member": member,"showNavigationBar": false,"isDebug":true,"clearCache":true] as [String : Any];
    
        // merchant.aigens.test
        // merchant.com.aigens.pay
        /// "stripePublishableKey": "pk_test_cxrXfdfcVnS9JOPSZ3e3FZ1H"
        OrderPlace.openUrl(caller: self, url: url, options: options) { (result) in
            print("result:\(result)")
        }
//        OrderPlace.openUrl(caller: self, url: url, options:options,);
    }
    
    private func forCdcTest() {
//        let url = "http://192.168.50.72:8102/#/StoreList/latitude/22.3993429/longitude/114.19149120000002";
        let url = "https://cdc-dev.order.place/#/StoreList/latitude/22.3993429/longitude/114.19149120000002"
//                let url = "http://192.168.0.253:8100/#/court-store-list/5175539845300224";
        //        let url = "http://localhost:8100/#/store/102945/mode/takeaway";
        
        var member = [String: Any]()
        
        member["memberId"] = "GUEST"
        member["session"] = "ABCDEF" //same as session
        member["source"] = "cdc"
        member["language"] = "zh" //en,zh,zh-cn
        member["name"] = "Optional Name" //Optional (with actual data)
        member["gender"] = "M" //Optional (with actual data)
        member["age"] = 25 //Optional (with actual data)
        member["phone"] = "65448231" //Optional (with actual data)
        member["email"] = "peter.liu@gmail.com" //Optional (with actual data)
        let systemOpenUrl : [String] = ["mailto:"];
        let options = ["features": "gps,scan,alipayhk,applepay","alipayScheme": "cdcAlipayScheme","appleMerchantIdentifier": "merchant.com.aigens.pay","member": member,"showNavigationBar": false,"isDebug":true,"clearCache":true] as [String : Any];
        
        // merchant.aigens.test
        // merchant.com.aigens.pay
        /// "stripePublishableKey": "pk_test_cxrXfdfcVnS9JOPSZ3e3FZ1H"
        OrderPlace.openUrl(caller: self, url: url, options: options) { (result) in
            print("result:\(result)")
        }
        //        OrderPlace.openUrl(caller: self, url: url, options:options,);
    }
    
    
    private func genkiTest() {
        //        let url = "http://192.168.50.72:8102/#/StoreList/latitude/22.3993429/longitude/114.19149120000002";
        let url = "http://192.168.50.72:8100/#/store/105118"
        //        let url = "http://192.168.0.253:8100/#/court-store-list/5175539845300224";
        //        let url = "http://localhost:8100/#/store/102945/mode/takeaway";
        
        var member = [String: Any]()
        
        member["memberId"] = "123456"
        member["session"] = "ABCDEF" //same as session
        member["source"] = "cdc"
        member["language"] = "zh" //en,zh,zh-cn
        member["name"] = "Optional Name" //Optional (with actual data)
        member["gender"] = "M" //Optional (with actual data)
        member["age"] = 25 //Optional (with actual data)
        member["phone"] = "65448231" //Optional (with actual data)
        member["email"] = "peter.liu@gmail.com" //Optional (with actual data)
        let systemOpenUrl : [String] = ["mailto:"];
        let options = ["features": "scan,alipayhk,applepay","alipayScheme": "cdcAlipayScheme","appleMerchantIdentifier": "merchant.com.aigens.pay","member": member,"showNavigationBar": false,"isDebug":true,"clearCache":true,"systemOpenUrl":systemOpenUrl,"language": "en"] as [String : Any];
        
        // merchant.aigens.test
        // merchant.com.aigens.pay
        /// "stripePublishableKey": "pk_test_cxrXfdfcVnS9JOPSZ3e3FZ1H"
        OrderPlace.openUrl(caller: self, url: url, options: options) { (result) in
            print("result:\(result)")
        }
        //        OrderPlace.openUrl(caller: self, url: url, options:options,);
    }
    
    
    private func testCardIOScan() {
//        let cardIO = CardIOExecutor()
//        cardIOExecutor = cardIO;
//        cardIO.testScan();
        
    }
    
    func scan() {
        
    }
    
     func test() {
    
            let url = "http://192.168.50.72:8100/#/store/105118/mode/takeaway"
//        let url = "http://192.168.50.72:8082/home";
            var member = [String: Any]()
            
            member["memberId"] = "GUEST"
            member["session"] = "ABCDEF" //same as session
            member["source"] = "cdc"
            member["language"] = "zh" //en,zh,zh-cn
            member["name"] = "Optional Name" //Optional (with actual data)
            member["gender"] = "M" //Optional (with actual data)
            member["age"] = 25 //Optional (with actual data)
            member["phone"] = "65448231" //Optional (with actual data)
            member["email"] = "peter.liu@gmail.com" //Optional (with actual data)
        
            let options = ["features": "gps,scan","member": member,"showNavigationBar": false,"isDebug":true,"clearCache":true] as [String : Any];
            OrderPlace.openUrl(caller: self, url: url, options: options) { (result) in
                print("result:\(result)")
            }
            //        OrderPlace.openUrl(caller: self, url: url, options:options,);
        }
    
    
    
    @IBAction func openClicked(_ sender: Any) {
        
//        testCardIOScan();
        
        
//        forLPTest()
        
        
//        forCdcTest();
//        test();
//        genkiTest();

//        return;
        
        
//        let url = "https://aigens-sdk-demo.firebaseapp.com/";
        
        
//        let url = "https://yoshinoya.order.place/#/store/200002/mode/pickup";
//        let url = "https://kiosktest.aigens.com/#/web/aigensstoretest/store/5741226267508736/station/0/time/1563434100532"
        
        
        
        
//        let url = "https://orderplacedemo.firebaseapp.com/#/store/5680455227539456/mode/takeaway";
//        let url = "http://dev.order.place/#/store/5680455227539456/mode/takeaway";
//        let url = "https://genkiuatp2.aigens.com/";
//        let url = "https://storage.googleapis.com/aigensstoretest.appspot.com/70000/ssptnc.html"
        
        
//        let url = "http://192.168.86.25:8101/#/court-store-list/5175539845300224";
//        let url = "https://www.baidu.com/";
//        let url = "https://test.order.place/#/court-store-list/5175539845300224";
//        let url = "https://aigens-sdk-demo.firebaseapp.com"
        let url = "https://test.order.place/#/court-store-list/5175539845300224";
//        let url = "https://scantest.aigens.com/scan?code=c3RvcmU9NTc1ODEzMDYyMTI1MTU4NCZtb2RlPXBpY2t1cCZwYWdlPWJ5b2Q=";
        
//        let url = "http://192.168.0.253:8100"

//        let url = "http://192.168.0.253:8101/#/court-store-list/5175539845300224";
        
        //var services = [GpsService()]
        
        // "appleMerchantIdentifier": "merchant.aigens.test" , -> support apple pay need set
        // alipay
//        let options = ["features": "gps,scan,alipayhk,wechatpay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.com.aigens.pay"];
        
        var member = [String: Any]()
        member["memberId"] = "200063"
//        member["session"] = "7499c956f4b1b225b14a985543c7526f" //same as session
        member["source"] = "lp club"
        member["language"] = "en" //en,zh,zh-cn
        member["name"] = "Him Lam" //Optional (with actual data)
        member["gender"] = "M" //Optional (with actual data)
        member["age"] = 17 //Optional (with actual data)
        member["phone"] = "94952850" //Optional (with actual data)
        member["email"] = "him.lam@aigens.com" //Optional (with actual data)
        
        var navigationbarStyle = [String: Any]();
//        navigationbarStyle["backText"] = "< 返回";
        navigationbarStyle["backArrow"] = true;
        navigationbarStyle["useBackButton"] = true;  /// default : false , 
        navigationbarStyle["backImagePath"] = OrderPlace.getImagePathWithName(name: "back", type: "png")
        navigationbarStyle["title"] = "title title title title title title";
        navigationbarStyle["backgroundColor"] = "#666666";
        navigationbarStyle["textColor"] = "#ffffff";
        navigationbarStyle["rightAction"] = true;
        navigationbarStyle["rightImagePath"] = OrderPlace.getImagePathWithName(name: "home", type: "png")
        
        
        
        var titleFontStyle = [String: Any]();
        titleFontStyle["size"] = 22; // default: 18
        titleFontStyle["font"] = 2;  // 0 (systemFont) / 1 (boldSystemFont) / 2 (italicSystemFont) , default: 0
        navigationbarStyle["titleFontStyle"] = titleFontStyle;
        
        var backFontStyle = [String: Any]();
        backFontStyle["size"] = 18; // default: 18
        backFontStyle["font"] = 0;  // 0 (systemFont) / 1 (boldSystemFont) / 2 (italicSystemFont) , default: 0
        navigationbarStyle["backFontStyle"] = backFontStyle;
//        open class func systemFont(ofSize fontSize: CGFloat) -> UIFont
        
//        open class func boldSystemFont(ofSize fontSize: CGFloat) -> UIFont
        
//        open class func italicSystemFont(ofSize fontSize: CGFloat) -> UIFont
        
        //case `default` // Dark content, for use on light backgrounds
        //case lightContent // Light content, for use on dark backgrounds
        // please add : View controller-based status bar appearance = NO in info;
        navigationbarStyle["statusBarStyle"] = 1;
        navigationbarStyle["statusbarBackgroundColor"] = "#3d9be5";
        
        
        var alertStyle = [String: Any]();
        
        alertStyle["themeColor"] = "#ffc933";
        alertStyle["onlyOKButton"] = false;
        alertStyle["titleLabel"] = "Add card incomplete, are you sure to exit?";
        alertStyle["subtitleLabel"] = "#ffc933";
        alertStyle["backgroundCanDismiss"] = true;
        
        
//        let systemOpenUrl = "octopus://,https://itunes.apple.com,https://search.itunes.apple.com";
        let systemOpenUrl : [String] = ["octopus://","https://itunes.apple.com","https://search.itunes.apple.com"];
        let options = ["features": "gps,scan,wechatpay,alipayhk,applepay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.com.aigens.pay","member": member,"isDebug":true,"systemOpenUrl":systemOpenUrl,"showNavigationBar":false,"navigationbarStyle": navigationbarStyle,"clearCache":true,"disableScroll": false, "canDismiss": false,"alertStyle" : alertStyle] as [String : Any];
//        "target" : "_system"
        // "stripePublishableKey": "pk_test_cxrXfdfcVnS9JOPSZ3e3FZ1H"
        // merchant.com.aigens.pay
        // merchant.aigens.test
        

        //OrderPlace.openUrl(caller: self, url: url, features:"gps,scan", services: services);
//        OrderPlace.openUrl(caller: self, url: url, options:options);
        OrderPlace.openUrl(caller: self, url: url, options: options) { (params) in
            print(" callback params:\(params)")
        }
    }
    
    func scanGenki() {
        var member = [String: Any]()
        
        member["memberId"] = "123456"
        member["session"] = "ABCDEF" //same as session
        member["source"] = "lp"
        member["language"] = "zh" //en,zh,zh-cn
        member["name"] = "Optional Name" //Optional (with actual data)
        member["gender"] = "M" //Optional (with actual data)
        member["age"] = 25 //Optional (with actual data)
        member["phone"] = "65448231" //Optional (with actual data)
        member["email"] = "peter.liu@gmail.com" //Optional (with actual data)
        let options = ["features": "gps,scan,alipayhk,applepay,wechatpay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.com.aigens.pay","member": member,"showNavigationBar": false,"isDebug":true,"onlyScan":true,"language": "en"] as [String : Any];
        
    }
    
    @IBAction func scanClicked(_ sender: Any) {
        
        if (true) {
            scanGenki();
        }
//        var member = [String: Any]()
//        member["memberId"] = "200063"
//        member["session"] = "7499c956f4b1b225b14a985543c7526f" //same as session
//        member["source"] = "lp club"
//        member["language"] = "en" //en,zh,zh-cn
//        member["name"] = "Him Lam" //Optional (with actual data)
//        member["gender"] = "M" //Optional (with actual data)
//        member["age"] = 17 //Optional (with actual data)
//        member["phone"] = "94952850" //Optional (with actual data)
//        member["email"] = "him.lam@aigens.com" //Optional (with actual data)
//        let options = ["features": "gps,scan,wechatpay,alipayhk,applepay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.aigens.test","member": member,"isDebug":true] as [String : Any];
        
        // "stripePublishableKey": "pk_test_Qz98hi2rnymhXsjWGfplG5dc"
        
        var member = [String: Any]()
        
        member["memberId"] = "123456"
        member["session"] = "ABCDEF" //same as session
        member["source"] = "lp"
        member["language"] = "zh" //en,zh,zh-cn
        member["name"] = "Optional Name" //Optional (with actual data)
        member["gender"] = "M" //Optional (with actual data)
        member["age"] = 25 //Optional (with actual data)
        member["phone"] = "65448231" //Optional (with actual data)
        member["email"] = "peter.liu@gmail.com" //Optional (with actual data)
        let options = ["features": "gps,scan,alipayhk,applepay,wechatpay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.aigens.test","member": member,"showNavigationBar": false,"isDebug":true,"onlyScan":true,"language": "en"] as [String : Any];
        
        OrderPlace.scanDecode(caller: self, options: options) { (value) in
            print("value:\(value)")
            
            if let v = value as? [String: String] , let url = v["decodeResult"] as? String{
                var member = [String: Any]()
                member["memberId"] = "200063"
                //        member["session"] = "7499c956f4b1b225b14a985543c7526f" //same as session
                member["source"] = "lp club"
                member["language"] = "en" //en,zh,zh-cn
                member["name"] = "Him Lam" //Optional (with actual data)
                member["gender"] = "M" //Optional (with actual data)
                member["age"] = 17 //Optional (with actual data)
                member["phone"] = "94952850" //Optional (with actual data)
                member["email"] = "him.lam@aigens.com" //Optional (with actual data)
                
                var navigationbarStyle = [String: Any]();
                //        navigationbarStyle["backText"] = "< 返回";
                navigationbarStyle["backArrow"] = true;
                navigationbarStyle["backImagePath"] = OrderPlace.getImagePathWithName(name: "back_test@2x", type: "png")
                navigationbarStyle["title"] = "title title title title title title";
                navigationbarStyle["backgroundColor"] = "#443532";
                navigationbarStyle["textColor"] = "#ffffff";
                
                var titleFontStyle = [String: Any]();
                titleFontStyle["size"] = 18; // default: 18
                titleFontStyle["font"] = 1;  // 0 (systemFont) / 1 (boldSystemFont) / 2 (italicSystemFont) , default: 0
                navigationbarStyle["titleFontStyle"] = titleFontStyle;
                
                var backFontStyle = [String: Any]();
                backFontStyle["size"] = 18; // default: 18
                backFontStyle["font"] = 0;  // 0 (systemFont) / 1 (boldSystemFont) / 2 (italicSystemFont) , default: 0
                navigationbarStyle["backFontStyle"] = backFontStyle;
                navigationbarStyle["statusBarStyle"] = 1;
                navigationbarStyle["statusbarBackgroundColor"] = "#3d9be5";

                let systemOpenUrl : [String] = ["octopus://","https://itunes.apple.com","https://search.itunes.apple.com"];
                let options = ["features": "gps,scan,wechatpay,alipayhk,applepay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.aigens.test","member": member,"isDebug":true,"systemOpenUrl":systemOpenUrl,"showNavigationBar":false,"navigationbarStyle": navigationbarStyle] as [String : Any];
                
                OrderPlace.openUrl(caller: self, url: url, options:options);
            }
        }
        
    }
    
    @IBAction func checkCameraP(_ sender: Any) {
        OrderPlace.checkCameraPermission { (permission) in
            print("permission:\(permission)")
            if (!permission) {
                OrderPlace.openSetting()
            }
        }
  
    }
    
}
