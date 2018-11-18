//
//  OrderPlaceService.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import WebKit

open class OrderPlaceService : NSObject {
    
    public var vc: UIViewController!;
    
    open func getServiceName() -> String{
        preconditionFailure("This method getServiceName must be overridden")
        //return "";
    }
    
    open func initialize(){
        
    }
    
    open func handleMessage(method: String, body: NSDictionary, callback: CallbackHandler?){
        preconditionFailure("This method handleMessage must be overridden")
        //return;
    }
}
