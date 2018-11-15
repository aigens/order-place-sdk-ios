//
//  NetsPayService.swift
//  OrderPlaceSdk_Example
//
//  Created by 陈培爵 on 2018/11/12.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import ENETSLib
class NetsPayService: OrderPlaceService {

    var options: [String: Any]?
    var netspayResultCallback: CallbackHandler? = nil
//    lazy var paymentManager: PaymentRequestManager = {
//        let paymentManager = PaymentRequestManager()
//        paymentManager.paymentDelegate = self
//        return paymentManager
//    }()

    init(_ options: [String: Any]) {
        super.init()
        self.options = options

    }

    override func initialize() {

    }
    override func getServiceName() -> String {
        return "NetsPayService"
    }

    override func handleMessage(method: String, body: NSDictionary, callback: CallbackHandler?) {
        switch method {
        case "requestPay":
            netspayResultCallback = callback
            requestPay(body: body, callback: callback)
            break;
        default:
            break;
        }
    }

    private func requestPay(body: NSDictionary, callback: CallbackHandler?) {
        print("body:\(body)--- callback:\(callback) self.vc:\(self.vc)")
        if let hmac = body.value(forKey: "hmac") as? String, let txnReq = body.value(forKey: "txnReq") as? String, let apiKey = body.value(forKey: "apiKey") as? String {

            let paymentManager = PaymentRequestManager()
            paymentManager.paymentDelegate = self
            let request = PaymentRequest(hmac: hmac, txnReq: txnReq)
            paymentManager.sendPaymentRequest(apiKey: apiKey, paymentRequest: request, viewController: self.vc)
        }

    }


}

extension NetsPayService: PaymentRequestDelegate {

    func onResult(response: PaymentResponse) {
        var hmac: String = ""
        var txnRes: String = ""
        var keyId: String = ""
        var txn_Status: String = ""
        var isDebitCredit: Bool = false

        // TODO SDK user need to handle payment response (refer to integration guide)
        if response is DebitCreditResponse {
            let debitCreditResponse = response as! DebitCreditResponse
            hmac = debitCreditResponse.hmac
            txnRes = debitCreditResponse.txnRes
            keyId = debitCreditResponse.keyId
            isDebitCredit = true

        } else if response is NonDebitCreditResponse {
            let nonDebitCreditResponse = response as! NonDebitCreditResponse
            txn_Status = nonDebitCreditResponse.txn_Status
            isDebitCredit = false
        }

        var r = [String: Any]()
        r["hmac"] = hmac
        r["txnRes"] = txnRes
        r["keyId"] = keyId
        r["txn_Status"] = txn_Status
        r["debitCredit"] = isDebitCredit
        r["onResult"] = true
        print("onResult response\(r)")
        let response = generateResultObject(r)

        DispatchQueue.main.async {[weak self] in
            self?.netspayResultCallback?.success(response: response)
        }

    }
    func onFailure(error: NETSError) {
        // TODO SDK user need to handle error code (refer to integration guide)
        let responseCode = error.responseCode
        let actionCode = error.actionCode
        var r = [String: Any]()
        r["responseCode"] = responseCode
        r["actionCode"] = actionCode
        r["onResult"] = false
        print("onFailure response\(r)")
        let response = generateResultObject(r)
        DispatchQueue.main.async {[weak self] in
            self?.netspayResultCallback?.success(response: response)
        }

    }
}
