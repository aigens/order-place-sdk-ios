//
//  OrderPlaceService.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 5/9/2018.
//

import Foundation
import WebKit

protocol OrderPlaceService {
    func handleMessage(method: String, body: Any, callback: CallbackHandler?) 
}
