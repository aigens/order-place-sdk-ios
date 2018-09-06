//
//  OrderPlace.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 2/9/2018.
//

import Foundation
import UIKit

public class OrderPlace {
    

    public static func openUrl(caller:UIViewController, url: String, features: String){
    
        print("open url")
        
        let podBundle = Bundle(for: OrderPlace.self)
        
        print("podBundle", podBundle.bundlePath)
        
        let storyboard = UIStoryboard(name: "OrderPlaceStoryboard", bundle: podBundle)
      
        print("storyboard", storyboard)
        
        let controller = storyboard.instantiateInitialViewController() as! UINavigationController;
        
        let orderVC = controller.topViewController as! OrderViewController;
        
        orderVC.url = url;
        orderVC.features = features;
        
        print("before open url", url, features)
        
        caller.present(controller, animated: true, completion: nil)
        
        print("presented open url", url, features)
    
    
    
    }
    
}
