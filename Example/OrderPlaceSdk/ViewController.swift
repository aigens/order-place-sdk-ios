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
        
        
//        let url = "http://192.168.86.60:8100/";
//        let url = "https://test.order.place/#/court-store-list/5175539845300224";
        let url = "https://aigens-sdk-demo.firebaseapp.com"
        //var services = [GpsService()]
        
        // "appleMerchantIdentifier": "merchant.aigens.test" , -> support apple pay need set
        // alipay
        let options = ["features": "gps,scan,alipayhk,wechatpay","alipayScheme": "alipaySchemes123"];
        
        //OrderPlace.openUrl(caller: self, url: url, features:"gps,scan", services: services);
        OrderPlace.openUrl(caller: self, url: url, options:options);
    }
    
    @IBAction func scanClicked(_ sender: Any) {
        
        let options = ["features": "gps,scan,wechatpayhk,wechatpay,alipay,alipayhk","alipayScheme": "alipaySchemes123"];
        
        OrderPlace.scan(caller: self, options:options);
    }
    
}

