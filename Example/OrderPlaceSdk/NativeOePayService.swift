//
//  NativeOePayService.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 18/11/2018.
//

import Foundation
import UIKit
import WebKit
import OrderPlaceSdk

class NativeOePayService: OrderPlaceService {
    
    var options: [String: Any]!;
    var payCallback: CallbackHandler?;
    
    override open func getServiceName() -> String{
        return "NativeOEPayService";
    }
    
    override open func handleMessage(method: String, body: NSDictionary, callback: CallbackHandler?) {
        
        print("NativeOEPayService", method, body)
        

        
        switch method{
            case "requestPay":
                requestPay(body: body, callback: callback);
                break;
            default:
                break;
            
        }
        
        
    }
    
    func requestPay(body: NSDictionary, callback: CallbackHandler?){
        
        self.payCallback = callback;
        
        let octopusToken = body["octopustoken"];
        
        print("octopustoken", octopusToken);
        
        //TODO: do payment with token
        
        //fake success
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2) ) {
            self.simulateSuccess();
        }
    }
    
    
    func simulateSuccess(){
        
        let time = Int(NSDate().timeIntervalSince1970 * 1000);

        let value = ["time":time];
        self.payCallback?.success(response: value as Any)
    }
    
    
}
