//
//  AlipayExecutor.swift
//  OrderPlaceSdk_Example
//
//  Created by 陈培爵 on 2018/11/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
@objc public class AlipayExecutor: NSObject {
    public required override init() {
        super.init()
    }

    private var webView: WKWebView? = nil
    private var alipayResultCallback: CallbackHandler? = nil

    private func showAlert(message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        //        self.vc.present(alertController, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    private func loadWithUrlStr(urlStr: String) {
        print("urlStr url:\(urlStr)");
        guard let url = URL(string: urlStr) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let webRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30.0)
            self.webView?.load(webRequest)
        }
    }

    private func payWithUrlOrder(urlOrder: String, alipayScheme: String) {
        AlipaySDK.defaultService().payUrlOrder(urlOrder, fromScheme: alipayScheme) { [weak self](dict) in
            print("payWithUrlOrder dict:\(dict)")
            guard let dictResult = dict else { return }
            if let isProcessUrlPay = dictResult[AnyHashable("isProcessUrlPay")] as? String, let urlStr = dictResult[AnyHashable("returnUrl")] as? String {
                if isProcessUrlPay == "1" {
                    self?.loadWithUrlStr(urlStr: urlStr)
                }
            }
        }

    }
}

extension AlipayExecutor: AlipayDelegate {

    public var AliapyWebView: WKWebView? {
        get {
            return nil
        }
        set {
            print("alipay set webView:\(webView)")
            self.webView = newValue
        }
    }


    public func AlipayOrder(body: NSDictionary, callback: CallbackHandler?) {
        // call back 是wap 支付的结果, 钱包支付的结果要在app delegate 中写
        if let params = body.value(forKey: "orderStringAlipay") as? String, let fromScheme = body.value(forKey: "alipayScheme") as? String {
            AlipaySDK.defaultService().payOrder(params, fromScheme: fromScheme) { (result) in
                print("payOrder result:\(result)")
                callback?.success(response: result as Any)
            }
            alipayResultCallback = callback
        } else {
            showAlert(message: "Parameter error")
        }

    }

    public func AlipayGetVersion(callback: CallbackHandler?) {
        if let version = AlipaySDK.currentVersion(AlipaySDK())() {
            let dict = ["alipaySdkVersion": version]
            callback?.success(response: dict)
        }
    }

    public func AlipayApplicationOpenUrl(_ app: UIApplication, url: URL) {
        // wallet pay
        // if SDK is not available, will open alipay APP to pay, then need to pass the payment result back //to development kit
        if url.host == "safepay" {

            //The merchant’s APP may be killed by the system while processing payment in alipay APP, //then the callback will fail. Please handle the return result of standbyCallback.
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { [weak self] (resultDict) in
                print("safepay wallet pay callback result:\(resultDict)")
                guard let dictResult = resultDict else { return }
                var response = Dictionary<String, Any>()
                if let resultStatus = dictResult[AnyHashable("resultStatus")] as? String {
                    response["resultStatus"] = resultStatus;
                }
//                if let result = dictResult[AnyHashable("result")] as? String {
//                    response["result"] = result;
//                }
                
                if let memo = dictResult[AnyHashable("memo")] as? String {
                    response["memo"] = memo;
                }
                print("response:\(response)")
                self?.alipayResultCallback?.success(response: response)
            })

            // 授权跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDict) in
                print("safepay processAuth_V2Result result:\(resultDict)")
                if let dictResult = resultDict, let result = dictResult["result"] as? String {
                    print("processAuth_V2 Result result ->:\(result)")
                }

            })

        } else if url.host == "platformapi" { //Alipay wallet express login authorization returns authCode
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { [weak self] (resultDict) in
                //The merchant’s APP may be killed by the system while processing payment in alipay //APP, then the callback will fail. Please handle the return result of standbyCallback.
                print("platformapi wallet pay callback result:\(resultDict)")
//                self?.alipayResultCallback?.success(response: resultDict)
            })

            // 授权跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDict) in
                print("platformapi processAuth_V2Result result:\(resultDict)")
                if let dictResult = resultDict, let result = dictResult["result"] as? String {
                    print("processAuth_V2 Result result ->:\(result)")
                }

            })

        }
    }

    public func AlipayFetchOrderInfo(url: String, alipayScheme: String) -> Bool {
        if let orderInfo = AlipaySDK.defaultService().fetchOrderInfo(fromH5PayUrl: url), orderInfo.count > 0 {
            self.payWithUrlOrder(urlOrder: orderInfo, alipayScheme: alipayScheme)
            return true
        } else {
            return false
        }

    }


}

