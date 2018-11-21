//
//  ConfigService.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import UIKit
import WebKit

class ConfigService: OrderPlaceService {
    
    var options: [String: Any]!;
    override func getServiceName() -> String {
        return "ConfigService";
    }
    
    var clickedExit: (() -> ())? = nil
    
    override func handleMessage(method: String, body: NSDictionary, callback: CallbackHandler?) {
        
        print("ConfigService2", method, body)
        
        switch method {
        case "back":
            back();
            break;
        case "getPreference":
            getPreference(pref: "default", name: body["name"] as! String, callback: callback);
            break;
        case "getConfig":
            getConfig(callback: callback);
            break;
        case "getParams":
            getParams(callback: callback);
            break;
        case "putPreference":
            putPreference(pref: "default", name: body["name"] as! String, value: body["value"] as Any, callback: callback);
            break;
        default:
            break;
            
        }
        
        
    }
    
    func back() {
        vc.navigationController?.dismiss(animated: true)
        if clickedExit != nil {
            clickedExit!()
        }
    }
    
    func getPreference(pref: String, name: String, callback: CallbackHandler?) {
        
        let value = UserDefaults.standard.object(forKey: name)
        
        print("getPref", name, value as Any)
        
        
        callback?.success(response: value as Any)
        
        
    }
    
    func getParams(callback: CallbackHandler?) {
        
        let value = self.options;
        
        print("getParams2", value as Any)
        
        callback?.success(response: value as Any)
        
        
    }
    
    func getConfig(callback: CallbackHandler?) {
        
        let value = [String: String]()
        callback?.success(response: value)
        
        
    }
    
    func putPreference(pref: String, name: String, value: Any, callback: CallbackHandler?) {
        
        UserDefaults.standard.set(value, forKey: name)
        
        print("putPreference", name, value)
        
    }
    
    
}

