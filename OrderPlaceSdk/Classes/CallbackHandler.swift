//
//  CallbackHandler.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation

protocol CallbackHandler {
    static func callback(data: NSDictionary)
}
