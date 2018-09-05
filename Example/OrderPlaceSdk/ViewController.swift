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
        
        OrderPlace.hello()
        OrderPlace.hello2()
        OrderViewController.hello();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openClicked(_ sender: Any) {
        
        print("open clicked")
        OrderPlace.openUrl(caller: self, url: "https://aigens-sdk-demo.firebaseapp.com/");
    }
    
}

