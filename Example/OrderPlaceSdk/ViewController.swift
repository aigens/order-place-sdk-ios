//
//  ViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 09/02/2018.
//  Copyright (c) 2018 Peter Liu. All rights reserved.
//

import UIKit
import OrderPlaceSdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openClicked(_ sender: Any) {
        
        var url = "https://aigens-sdk-demo.firebaseapp.com/";
        
        url = "https://aigens-octopus-demo.firebaseapp.com/";
        
        //var services = [GpsService()]
        var services = [NativeOePayService()];
        
        let options = ["features": "gps,scan"];
        
        OrderPlace.openUrl(caller: self, url: url, options:options, services: services);
        //OrderPlace.openUrl(caller: self, url: url, options:options);
    }
    
    @IBAction func scanClicked(_ sender: Any) {
        
        let options = ["features": "gps,scan"];
        
        OrderPlace.scan(caller: self, options:options);
    }
    
}

