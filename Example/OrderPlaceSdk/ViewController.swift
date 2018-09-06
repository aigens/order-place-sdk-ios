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
        
        url = "http://192.168.86.52:8100/";
        
        OrderPlace.openUrl(caller: self, url: url, features:"gps,scan");
    }
    
}

