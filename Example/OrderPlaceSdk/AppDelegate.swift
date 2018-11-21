//
//  AppDelegate.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 09/02/2018.
//  Copyright (c) 2018 Peter Liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        OrderPlace.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    // // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        OrderPlace.application(app, open: url)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        OrderPlace.application(application, open: url)
        
        return true
    }


}

