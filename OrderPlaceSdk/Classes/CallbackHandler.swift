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


    public func success(response: Any) {

        print("response:\(response)")
        if(callback == nil) {
            return;
        }

        var str: String = "null";


        do {
            if JSONSerialization.isValidJSONObject(response) {
                let data = try JSONSerialization.data(withJSONObject: response)
                if let s = String(data: data, encoding: String.Encoding.utf8) {
                    str = s;
                }
            }
        } catch {
            print("json serialization error")
        }

        let scriptSource = callback + "('" + str + "')"

        print("callback", callback)
        print("script", scriptSource)

        self.webView.evaluateJavaScript(scriptSource)
    }

}

