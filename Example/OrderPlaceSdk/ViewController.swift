//
//  ViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 09/02/2018.
//  Copyright (c) 2018 Peter Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func openClicked(_ sender: Any) {
        
        //let url = "https://aigens-sdk-demo.firebaseapp.com/";
//        let url = "https://orderplacedemo.firebaseapp.com/#/store/5680455227539456/mode/takeaway";
//        let url = "http://192.168.0.249:8100/#/store/5680455227539456/mode/takeaway";
        
        
//        let url = "http://192.168.86.25:8101/#/court-store-list/5175539845300224";
//        let url = "https://www.baidu.com/";
//        let url = "https://test.order.place/#/court-store-list/5175539845300224";
        let url = "https://aigens-sdk-demo.firebaseapp.com"
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
        let options = ["features": "gps,scan,wechatpayhk,alipayhk,applepay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.com.aigens.pay","member": member] as [String : Any];
        

        //OrderPlace.openUrl(caller: self, url: url, features:"gps,scan", services: services);
        OrderPlace.openUrl(caller: self, url: url, options:options);
    }
    
    @IBAction func scanClicked(_ sender: Any) {
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
        let options = ["features": "gps,scan,wechatpayhk,alipayhk,applepay","alipayScheme": "alipaySchemes123","appleMerchantIdentifier": "merchant.com.aigens.pay","member": member] as [String : Any];
        
        OrderPlace.scan(caller: self, options:options);
    }
    
}

