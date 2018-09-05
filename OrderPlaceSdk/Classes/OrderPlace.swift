//
//  OrderPlace.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 2/9/2018.
//

import Foundation
import UIKit

public class OrderPlace {
    
    public static func hello() {
        print("hello world")
    }
    
    public static func hello2() {
        print("hello world2")
    }
    
    public static func openUrl(caller:UIViewController, url: String){
    
        let podBundle = Bundle(for: OrderPlace.self)
        
        //let bundleURL = podBundle.url(forResource: "OrderPlaceSdk", withExtension: "bundle")
        //let bundle = Bundle(url: bundleURL!)!
        
        let storyboard = UIStoryboard(name: "OrderPlaceStoryboard", bundle: podBundle)
        
        //let controller = storyboard.instantiateViewController(withIdentifier: "OrderViewController")
        //caller.present(controller, animated: true, completion: nil)
    
        let controller = storyboard.instantiateInitialViewController()!;
        caller.present(controller, animated: true, completion: nil)
        
        
        print("presented open url")
    
    
    
    }
    
}
