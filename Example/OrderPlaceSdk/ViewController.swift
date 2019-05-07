//
//  ViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 09/02/2018.
//  Copyright (c) 2018 Peter Liu. All rights reserved.
//

import UIKit

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
//        let url = "https://test.order.place/#/court-store-list/5175539845300224";
//        let url = "http://192.168.0.253:8100/#/court-store-list/5175539845300224";
        let url = "http://localhost:8100/#/store/102945/mode/takeaway";
        
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
        let options = ["features": "gps,scan,alipayhk,applepay,wechatpay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.aigens.test","member": member,"showNavigationBar": false,"isDebug":true] as [String : Any];
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

    @IBAction func openClicked(_ sender: Any) {
        
//        testCardIOScan();
        
        
        forLPTest()
        
        return;
        
        
        //let url = "https://aigens-sdk-demo.firebaseapp.com/";
//        let url = "https://orderplacedemo.firebaseapp.com/#/store/5680455227539456/mode/takeaway";
//        let url = "http://192.168.0.249:8100/#/store/5680455227539456/mode/takeaway";
        
        
//        let url = "http://192.168.86.25:8101/#/court-store-list/5175539845300224";
//        let url = "https://www.baidu.com/";
//        let url = "https://test.order.place/#/court-store-list/5175539845300224";
//        let url = "https://aigens-sdk-demo.firebaseapp.com"
//        let url = "https://test.order.place/#/court-store-list/5175539845300224";
        
        
//        let url = "http://192.168.0.253:8100"

        let url = "http://192.168.0.253:8101/#/court-store-list/5175539845300224";
        
        //var services = [GpsService()]
        
        // "appleMerchantIdentifier": "merchant.aigens.test" , -> support apple pay need set
        // alipay
//        let options = ["features": "gps,scan,alipayhk,wechatpay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.com.aigens.pay"];
        
        var member = [String: Any]()
        member["memberId"] = "200063"
        member["session"] = "7499c956f4b1b225b14a985543c7526f" //same as session
        member["source"] = "lp club"
        member["language"] = "en" //en,zh,zh-cn
        member["name"] = "Him Lam" //Optional (with actual data)
        member["gender"] = "M" //Optional (with actual data)
        member["age"] = 17 //Optional (with actual data)
        member["phone"] = "94952850" //Optional (with actual data)
        member["email"] = "him.lam@aigens.com" //Optional (with actual data)
        let options = ["features": "gps,scan,wechatpay,alipayhk,applepay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.aigens.test","member": member,"isDebug":true] as [String : Any];
        // "stripePublishableKey": "pk_test_cxrXfdfcVnS9JOPSZ3e3FZ1H"
        // merchant.com.aigens.pay
        // merchant.aigens.test
        

        //OrderPlace.openUrl(caller: self, url: url, features:"gps,scan", services: services);
        OrderPlace.openUrl(caller: self, url: url, options:options);
    }
    
    @IBAction func scanClicked(_ sender: Any) {
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
        let options = ["features": "gps,scan,alipayhk,applepay,wechatpay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.aigens.test","member": member,"showNavigationBar": false,"isDebug":true] as [String : Any];
        
        OrderPlace.scan(caller: self, options:options);
    }
    
    
}
