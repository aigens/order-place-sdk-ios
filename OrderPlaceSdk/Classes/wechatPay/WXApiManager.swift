//
//  WXApiManager.swift
//  testNewSdkSwift
//
//  Created by 陈培爵 on 2018/9/12.
//  Copyright © 2018年 PeiJueChen. All rights reserved.
//

import UIKit

class WXApiManager: NSObject {
    static let sharedInstance = WXApiManager()
    var wechatPayResultCallback: CallbackHandler? = nil
    private override init() { }
}

extension WXApiManager: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        print("WXApiManager req:\(resp)")
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0: // success
                
                break;
            default:  // failure
                
                break;
            }
        }

        print("resp:\(resp.errCode) --- \(resp.type)")
        if resp.errCode == 0 && resp.type == 0 { //授权成功
//            let response = resp as! SendAuthResp
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
        }
        
        if wechatPayResultCallback != nil && resp.isKind(of: PayResp.self) {
            
            var dict : [String : Any] = [:];
            dict["errCode"] = resp.errCode;  // 0 success :  -1  fail   -2 cancel
            dict["type"] = resp.type;
            dict["errStr"] = resp.errStr;
            dict["resp"] = resp.description
            print("resp.description:\(resp.description)")
            wechatPayResultCallback?.success(response: dict);
        }

    }

    func onReq(_ req: BaseReq!) {
        print("WXApiManager req:\(req)")
    }
}
