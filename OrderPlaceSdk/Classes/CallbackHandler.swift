//
//  CallbackHandler.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import UIKit
import WebKit

public class CallbackHandler {
    
    public var cc: WKUserContentController!;
    public var callback: String!;
    public var webView: WKWebView!;
    
   
    public func success(response: Any){
        
        if(callback == nil){
            return;
        }
        
        var str: String = "null";
        
        do{
            
            let data = try JSONSerialization.data(withJSONObject: response)
            str = String(data: data, encoding: String.Encoding.utf8)!
            
            
        }catch{
            print("json serialization error")
        }
        
        let scriptSource = callback + "('" + str + "')"
        
        print("callback", callback)
        print("script", scriptSource)
        
        self.webView.evaluateJavaScript(scriptSource)
    }
}
