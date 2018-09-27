//
//  WechatpayService.swift
//  testNewSdkSwift
//
//  Created by 陈培爵 on 2018/9/12.
//  Copyright © 2018年 PeiJueChen. All rights reserved.
//

import UIKit

class WechatpayService: OrderPlaceService {

    static public let SERVICE_NAME: String = "WechatpayService"
    var wechatPayResultCallback: CallbackHandler? = nil

    override func initialize() {

    }

    override func getServiceName() -> String {
        return WechatpayService.SERVICE_NAME
    }

    override func handleMessage(method: String, body: NSDictionary, callback: CallbackHandler?) {
        switch method {
        case "requestPay":
            wechatPayResultCallback = callback;
            payOrder(body: body, callback: callback)
            break;
        default:
            break;
        }
    }

    private func payOrder(body: NSDictionary, callback: CallbackHandler?) {
        if (!WXApi.isWXAppInstalled()) {
            let dict = ["result": "failure", "desc": "This app does not have WeChat installed.","errCode": "-1"];
            callback?.success(response: dict);
            return;
        }

        let req = PayReq();
        
        if let openId = body.object(forKey: "appId") as? String , openId != "" {
            req.openID = openId;  //由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录
        }
        
        if let partnerId = body.object(forKey: "partnerId") as? String {
            req.partnerId = partnerId; // 商户号
        }
        
        if let prepayId = body.object(forKey: "prepayId") as? String {
            req.prepayId = prepayId; // 预支付交易会话ID
        }
        
        if let nonceStr = body.object(forKey: "nonceStr") as? String {
            req.nonceStr = nonceStr; // 随机字符串
        }
        
        if let timeStamp = body.object(forKey: "timeStamp") as? UInt32 {
            req.timeStamp = timeStamp; // 时间戳，
        }
        
        if let package = body.object(forKey: "package") as? String {
            req.package = package; // 扩展字段
        }
        if let sign = body.object(forKey: "sign") as? String {
            req.sign = sign; // 签名 , 对 调用统一下单API之后返回的数据 进行签名
        }
        print("req:\(req)")
        WXApi.send(req);
        
        // send call back
        WXApiManager.sharedInstance.wechatPayResultCallback = callback;
        

    }
}
