//
//  OrderPlace.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 2/9/2018.
//

import Foundation
import UIKit

public class OrderPlace {
    
    private static func makeViewController(vcId: String) -> UIViewController{
        
        let podBundle = Bundle(for: OrderPlace.self)
        
        print("podBundle", podBundle.bundlePath)
        
        let bundleURL = podBundle.url(forResource: "OrderPlaceSdk", withExtension: "bundle")
        
        var bundle = podBundle
        
        if(bundleURL != nil){
            bundle = Bundle(url: bundleURL!)!
        }
        
        let storyboard = UIStoryboard(name: "OrderPlaceStoryboard", bundle: bundle)
        
        print("storyboard", storyboard)
        
        let controller = storyboard.instantiateViewController(withIdentifier: vcId);
        
        
        return controller;
        
    }

    public static func openUrl(caller:UIViewController, url: String, options: [String:Any]){
    
        print("open url")
        
        let controller = makeViewController(vcId: "OrderViewControllerNav") as! UINavigationController;
        
        let orderVC = controller.topViewController as! OrderViewController;
        
        orderVC.url = url;
        orderVC.options = options;
        
        caller.present(controller, animated: true, completion: nil)
        
    }
    
    public static func openUrl(caller:UIViewController, url: String, options: [String:Any], services: Array<OrderPlaceService>){
        
        print("open url")
        
        let controller = makeViewController(vcId: "OrderViewControllerNav") as! UINavigationController;
        
        let orderVC = controller.topViewController as! OrderViewController;
        
        orderVC.url = url;
        orderVC.options = options;
        orderVC.extraServices = services;
        
        caller.present(controller, animated: true, completion: nil)
        
        
        openUrl(caller: caller, url: url, options: options)
        
    }
    
    public static func scan(caller:UIViewController, options: [String:Any]){
        
        let controller = makeViewController(vcId: "ScannerViewControllerNav") as! UINavigationController;
        
        let scanVC = controller.topViewController as! ScannerViewController;
        
        scanVC.options = options;
        
        caller.present(controller, animated: true, completion: nil)
        
    }
    
    
    
}
