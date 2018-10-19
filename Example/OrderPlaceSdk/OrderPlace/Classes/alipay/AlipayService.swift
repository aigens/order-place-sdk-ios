//
//  AlipayService.swift
//  testNewSdkSwift
//
//  Created by 陈培爵 on 2018/9/11.
//  Copyright © 2018年 PeiJueChen. All rights reserved.
//

import UIKit

class AlipayService: OrderPlaceService {

    static public let SERVICE_NAME: String = "AlipayService"
    static public let appScheme: String = "alipaySchemes123"
    
    var payResultCallback: CallbackHandler? = nil

    override func initialize() {
    }

    override func getServiceName() -> String {
        return AlipayService.SERVICE_NAME
    }

    // body: params
    override func handleMessage(method: String, body: NSDictionary, callback: CallbackHandler?) {
        switch method {
        case "requestPay":
            payResultCallback = callback
            payOrder(body: body, callback: callback)
            break;
        case "getAlipaySdkVersion":
            getVersion(callback: callback)
            break;
        default:
            break;
        }
    }

    private func getVersion(callback: CallbackHandler?) {

        if let version = AlipaySDK.currentVersion(AlipaySDK())() {
            //print("version:\(version)")
            let dict = ["alipaySdkVersion": version]
            callback?.success(response: dict)
        }

    }

    // wap pay
    private func payOrder(body: NSDictionary, callback: CallbackHandler?) {

        // call back 是wap 支付的结果, 钱包支付的结果要在app delegate 中写
        AlipaySDK.defaultService().payOrder(body.value(forKey: "orderStr") as? String ?? "", fromScheme: AlipayService.appScheme) { (result) in
            print("payOrder result:\(result)")

            callback?.success(response: result)

            /*
            guard let resultDict = (result as? [String: Any]) else { return }
            if let status = resultDict["resultStatus"] as? String, status == "9000" {
                callback?.success(response: resultDict)
            } else {

            }
             */

        }
    }
}
