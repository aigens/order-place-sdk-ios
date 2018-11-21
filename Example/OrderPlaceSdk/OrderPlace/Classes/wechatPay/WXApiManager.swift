//
//  WXApiManager.swift
//  OrderPlaceSdk_Example
//
//  Created by 陈培爵 on 2018/11/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
private let SharedManager = WXApiManager()
class WXApiManager: NSObject, WXApiDelegate {

    static var sharedManager: WXApiManager {
        return SharedManager
    }

    var payResultCallback: CallbackHandler? = nil

    //MARK:- WXApiDelegate , req
    func onReq(_ req: BaseReq!) {
        debugPrint("onReq:\(req)")
    }
    //MARK:- WXApiDelegate , resp
    func onResp(_ resp: BaseResp!) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        debugPrint("onResp:\(resp)")
        if resp.isKind(of: PayResp.classForCoder()) {
            var errCode: Int32 = 0
            var result: Bool = false
            var errStr: String = ""

            switch resp.errCode {
            case WXSuccess.rawValue:
                errCode = resp.errCode   // 0
                result = true
                break
            default:
                errCode = resp.errCode
                errStr = resp?.errStr ?? ""
                result = false
                break
            }
            
            let dict = ["errCode": errCode, "result": result, "errStr": errStr] as [String: Any]
            payResultCallback?.success(response: dict)
        }

    }
}

