//
//  OrderPlaceService.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import WebKit

public class OrderPlaceService: NSObject {

    public var vc: UIViewController!;

    func getServiceName() -> String {
        preconditionFailure("This method getServiceName must be overridden")
        //return "";
    }

    func initialize() {
        

    }

    func handleMessage(method: String, body: NSDictionary, callback: CallbackHandler?) {
        preconditionFailure("This method handleMessage must be overridden")
        //return;
    }

    func generateResultObject(_ value: Any) -> [String: Any] {
        return ["result": value]
    }
}
