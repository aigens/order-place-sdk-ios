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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

