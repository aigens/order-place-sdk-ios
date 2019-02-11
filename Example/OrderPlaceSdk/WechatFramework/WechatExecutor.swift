//
//  WechatExecutor.swift
//  OrderPlaceSdk_Example
//
//  Created by 陈培爵 on 2018/11/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

@objc public class WechatExecutor: NSObject {

    public required override init() {
        super.init()
    }

    @objc public static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let dictArray = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [Dictionary<String, Any>] {
            for dicts in dictArray {
                if let dict = dicts["CFBundleURLName"] as? String, dict == "weixin", let arrayCFBundleURLSchemes = dicts["CFBundleURLSchemes"] as? [String], let weixinURLSchemes = arrayCFBundleURLSchemes.first {

                    WXApi.registerApp(weixinURLSchemes, enableMTA: true)
                    //print("weixinURLSchemes:\(weixinURLSchemes)")
                    break;
                }

            }
        }
    }

    private var payResultCallback: CallbackHandler? = nil

    private func showAlert(message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
//        self.vc.present(alertController, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
extension WechatExecutor: WeChatPayDelegate {
    public func wechatPayOrder(body: NSDictionary, callback: CallbackHandler?) {
        if !WXApi.isWXAppInstalled() {
            self.showAlert(message: "Please install WeChat first.")
            return
        }
        payResultCallback = callback

        /* test
        let urlString = "https://wxpay.wxutil.com/pub_v2/app/app_pay.php?plat=ios"
        let request = URLRequest(url: URL(string: urlString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { (response, data, error) in
            if error == nil && data != nil {
                let dictT = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                print("dictT:\(dictT)")
                if let dict = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary, dict != nil {
                    if let partnerId = dict!.value(forKey: "partnerid") as? String, let prepayId = dict!.value(forKey: "prepayid") as? String, let nonceStr = dict!.value(forKey: "noncestr") as? String, let timeStamp = dict!.value(forKey: "timestamp") as? UInt32, let package = dict!.value(forKey: "package") as? String, let sign = dict!.value(forKey: "sign") as? String {
                        let req = PayReq()
                        req.partnerId = partnerId
                        req.prepayId = prepayId
                        req.nonceStr = nonceStr
                        req.timeStamp = timeStamp
                        req.package = package
                        req.sign = sign
                        WXApi.send(req)
                    }
                }
            }
        }
         */


        if let partnerId = body.value(forKey: "partnerId") as? String, let prepayId = body.value(forKey: "prepayId") as? String, let nonceStr = body.value(forKey: "nonceStr") as? String, let timeStamp = body.value(forKey: "timeStamp") as? UInt32, let package = body.value(forKey: "packageValue") as? String, let sign = body.value(forKey: "sign") as? String {
            let req = PayReq()
            req.partnerId = partnerId
            req.prepayId = prepayId
            req.nonceStr = nonceStr
            req.timeStamp = timeStamp
            req.package = package
            req.sign = sign
            WXApi.send(req)
        } else {
            debugPrint("params format error")
        }
    }

    public func wechatGetVersion(callback: CallbackHandler?) {
        if let version = WXApi.getVersion() {
            let dict = ["wechatSdkVersion": version]
            debugPrint("wechatSdkVersion:\(version)")
            callback?.success(response: dict)
        }
    }

    public func wechatApplicationOpenUrl(_ app: UIApplication, url: URL) {
        let wxapiManager = WXApiManager.sharedManager
        wxapiManager.payResultCallback = payResultCallback
        WXApi.handleOpen(url, delegate: wxapiManager)

    }


}

