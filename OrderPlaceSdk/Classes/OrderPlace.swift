//
//  OrderPlace.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 2/9/2018.
//

import Foundation
import UIKit

public class OrderPlace {
    

    public static func openUrl(caller:UIViewController, url: String){
    
        let podBundle = Bundle(for: OrderPlace.self)
        
        let storyboard = UIStoryboard(name: "OrderPlaceStoryboard", bundle: podBundle)
      
        let controller = storyboard.instantiateInitialViewController() as! UINavigationController;
        
        let orderVC = controller.topViewController as! OrderViewController;
        
        orderVC.url = url;
        
        caller.present(controller, animated: true, completion: nil)
        
        print("presented open url")
    
    
    
    }
    
}
