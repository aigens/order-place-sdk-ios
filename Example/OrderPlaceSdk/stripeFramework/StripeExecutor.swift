//
//  StripeExecutor.swift
//  OrderPlaceSdk_Example
//
//  Created by 陈培爵 on 2019/1/29.
//  Copyright © 2019年 CocoaPods. All rights reserved.
//

import UIKit
import Stripe
import PassKit
import AddressBook
@objc class StripeExecutor: NSObject {
    public required override init() {
        super.init()
    }
    typealias completionBlock = (PKPaymentAuthorizationStatus) -> ()

    private var merchantIdentifier: String? = nil
    private var stripePublishableKey: String? = nil
    var privateOptions: [String: Any]? = nil
    var VC:UIViewController? = nil;

    private var supportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
//    private var merchantCapabilities : PKMerchantCapability = PKMerchantCapability(rawValue: PKMerchantCapability.RawValue(UInt8(PKMerchantCapability.capability3DS.rawValue) | UInt8(PKMerchantCapability.capabilityEMV.rawValue)))
    private var merchantCapabilities : PKMerchantCapability = [.capability3DS , .capabilityEMV]
//    private var merchantCapabilities : PKMerchantCapability = [.capability3DS]


    private var completion: completionBlock?
    private var payResultCallback: CallbackHandler? = nil

}

extension StripeExecutor {
    private func showAlert(_ message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        //        self.vc.present(alertController, animated: true, completion: nil)
        VC?.present(alertController, animated: true, completion: nil)
    }

    private func permissionIsVaild(_ body: NSDictionary) -> Bool {
        if merchantIdentifier == nil {
            showAlert("miss apple merchant identifier")
            return false
        }
        
        if let stripePublishableKey = body["stripePublishableKey"] as? String {
            self.stripePublishableKey = stripePublishableKey
            JJPrint("stripePublishableKey:\(stripePublishableKey)")
            STPPaymentConfiguration.shared().publishableKey = stripePublishableKey;
        } else {
            showAlert("miss stripe publishable key")
            return false;
        }
        return true;
    }

}

extension StripeExecutor {
    private func makePaymentRequest(_ body: NSDictionary, _ callback: CallbackHandler?) {
        JJPrint("apple pay body:\(body) callback:\(callback)")
        
        guard permissionIsVaild(body) else { return }
        guard canMakePayments() else { return }

        
        completion = nil

        var request :PKPaymentRequest!
        request = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier!)
        if request == nil {
            showAlert("PKPaymentRequest is nil")
            return;
        }
  
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = merchantCapabilities
        //request info
        if let currencyCode = body.value(forKey: "currencyCode") as? String {
            request.currencyCode = currencyCode
        }
        if let countryCode = body.value(forKey: "countryCode") as? String {
            request.countryCode = countryCode
        }

        if let merchantIdentifier = merchantIdentifier {
            request.merchantIdentifier = merchantIdentifier
        }

        request.requiredBillingAddressFields = billingAddressRequirementFromBody(body)
        request.requiredShippingAddressFields = shippingAddressRequirementFromArgumentsBody(body)
        if #available(iOS 8.3, *) {
            request.shippingType = shippingTypeFromBody(body)
        }
        request.shippingMethods = shippingMethodsFromBody(body)
        request.paymentSummaryItems = itemsFromBody(body)


        let authVC = PKPaymentAuthorizationViewController(paymentRequest: request)
        authVC?.delegate = self

        if let authVC = authVC {
            VC?.present(authVC, animated: true, completion: nil)
        } else {
            showAlert("PKPaymentAuthorizationViewController was nil.")
            return
        }


    }

    private func canMakePayments() -> Bool {
        var canPayment = false
        if PKPaymentAuthorizationViewController.canMakePayments() {
            if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_8_0) { // < ios8.0
                showAlert("This device cannot make payments.")
            } else if #available(iOS 9.0, *) {
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks, capabilities:merchantCapabilities) {
                    // This device can make payments and has a supported card"
                    canPayment = true
                } else {
                    showAlert("This device can make payments but has no supported cards.")
                }
            } else if #available(iOS 8.0, *) {
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks) {
                    // This device can make payments and has a supported card , in ios 8
                    canPayment = true
                } else {
                    showAlert("This device can make payments but has no supported cards.")
                }
            } else {
                showAlert("This device cannot make payments.")
            }
        } else {
            showAlert("This device cannot make payments.")
        }
        return canPayment;
    }

    private func completeLastTransaction(_ body: NSDictionary, _ callback: CallbackHandler?) {
        let paymentAuthorizationStatusString = self.paymentAuthorizationStatusFromBody(body)
        completion?(paymentAuthorizationStatusString)
    }

    private func shippingMethodsFromBody(_ body: NSDictionary) -> [PKShippingMethod] {
        var methods: [PKShippingMethod] = []
        if let tempMethods = body.value(forKey: "shippingMethods") as? Array<Dictionary<String, Any>> {
            for tempMethod in tempMethods {
                JJPrint("payment method:\(tempMethod)")
                let method = PKShippingMethod()
                if let lable = tempMethod["label"] as? String, let amount = tempMethod["amount"], let decimalValue = (amount as AnyObject).decimalValue {
                    let amountNumber = NSDecimalNumber(decimal: decimalValue)
                    method.label = lable
                    method.amount = amountNumber
                }
                let identifier = tempMethod["identifier"] as? String
                let detail = tempMethod["detail"] as? String
                method.detail = detail
                method.identifier = identifier
                methods.append(method)
            }
        }
        return methods;
    }

    private func itemsFromBody(_ body: NSDictionary) -> [PKPaymentSummaryItem] {
        var items: [PKPaymentSummaryItem] = []
        if let tempItems = body.value(forKey: "items") as? Array<Dictionary<String, Any>> {
            for item in tempItems {
                //                JJPrint("payment item:\(item)")
                if let lable = item["label"] as? String, let amount = item["amount"], let decimalValue = (amount as AnyObject).decimalValue {
                    let amountNumber = NSDecimalNumber(decimal: decimalValue)
                    let newItem = PKPaymentSummaryItem(label: lable, amount: amountNumber)
                    items.append(newItem)
                }
            }
        }
        return items
    }

    @available(iOS 8.3, *)
    private func shippingTypeFromBody(_ body: NSDictionary) -> PKShippingType {
        if let shippingType = body.value(forKey: "shippingType") as? String {
            if shippingType == "shipping" {
                return PKShippingType.shipping
            } else if shippingType == "delivery" {
                return PKShippingType.delivery
            } else if shippingType == "store" {
                return PKShippingType.storePickup
            } else if shippingType == "service" {
                return PKShippingType.servicePickup
            }
        }
        return PKShippingType.shipping
    }

    private func shippingAddressRequirementFromArgumentsBody(_ body: NSDictionary) -> PKAddressField {
        if let shippingAddressRequirement = body.value(forKey: "shippingAddressRequirement") as? String {
            if shippingAddressRequirement == "none" {
                return PKAddressField.init(rawValue: 0) // none
            } else if shippingAddressRequirement == "all" {
                return PKAddressField.all
            } else if shippingAddressRequirement == "postcode" {
                return PKAddressField.postalAddress
            } else if shippingAddressRequirement == "name" {
                if #available(iOS 8.3, *) {
                    return PKAddressField.name
                }
            } else if shippingAddressRequirement == "email" {
                return PKAddressField.email
            } else if shippingAddressRequirement == "phone" {
                return PKAddressField.phone
            }
        }
        return PKAddressField.init(rawValue: 0) // none
    }

    private func billingAddressRequirementFromBody(_ body: NSDictionary) -> PKAddressField {
        if let billingAddressRequirement = body.value(forKey: "billingAddressRequirement") as? String {
            if billingAddressRequirement == "none" {
                return PKAddressField.init(rawValue: 0) // none
            } else if billingAddressRequirement == "all" {
                return PKAddressField.all
            } else if billingAddressRequirement == "postcode" {
                return PKAddressField.postalAddress
            } else if billingAddressRequirement == "name" {
                if #available(iOS 8.3, *) {
                    return PKAddressField.name
                }
            } else if billingAddressRequirement == "email" {
                return PKAddressField.email
            } else if billingAddressRequirement == "phone" {
                return PKAddressField.phone
            }
        }
        return PKAddressField.init(rawValue: 0) // none
    }

    private func paymentAuthorizationStatusFromBody(_ body: NSDictionary) -> PKPaymentAuthorizationStatus {

        if let paymentAuthorizationStatus = body.value(forKey: "paymentAuthorizationStatus") as? String {
            if paymentAuthorizationStatus == "success" {
                return PKPaymentAuthorizationStatus.success
            } else if paymentAuthorizationStatus == "failure" {
                return PKPaymentAuthorizationStatus.failure
            } else if paymentAuthorizationStatus == "invalid-billing-address" {
                return PKPaymentAuthorizationStatus.invalidBillingPostalAddress
            } else if paymentAuthorizationStatus == "invalid-shipping-address" {
                return PKPaymentAuthorizationStatus.invalidShippingPostalAddress
            } else if paymentAuthorizationStatus == "invalid-shipping-contact" {
                return PKPaymentAuthorizationStatus.invalidShippingContact
            } else if paymentAuthorizationStatus == "require-pin" {
                if #available(iOS 9.2, *) {
                    return PKPaymentAuthorizationStatus.pinRequired
                }
            } else if paymentAuthorizationStatus == "incorrect-pin" {
                if #available(iOS 9.2, *) {
                    return PKPaymentAuthorizationStatus.pinIncorrect
                }
            } else if paymentAuthorizationStatus == "locked-pin" {
                if #available(iOS 9.2, *) {
                    return PKPaymentAuthorizationStatus.pinLockout
                }
            }
        }
        return PKPaymentAuthorizationStatus.failure
    }
}

extension StripeExecutor: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    // payment result
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        STPAPIClient.shared().createToken(with: payment) { [weak self] (token:STPToken?, error:Error?) in

            var response = self?.formatPaymentForApplication(payment)

            JJPrint("response:\(response ) token:\(token)  --:\(error.debugDescription)")
            if error == nil ,let tk = token , response != nil{
                response!["stripeToken"] = tk.tokenId;
            } else if (response != nil && error != nil) {
                response!["stripeToken"] = nil
                response!["errorDescription"] = error?.localizedDescription
            }
            self?.payResultCallback?.success(response: response ?? [String : Any]());

        }
        
//
        self.completion = completion

    }

    private func formatPaymentForApplication(_ payment: PKPayment) -> Dictionary<String, Any> {

        let paymentData = payment.token.paymentData.base64EncodedString()
        var response = Dictionary<String, Any>()
        response["paymentData"] = paymentData
        response["transactionIdentifier"] = payment.token.transactionIdentifier
        var typeCard = "error"
        if #available(iOS 9.0, *) {
            response["paymentMethodDisplayName"] = payment.token.paymentMethod.displayName
            response["paymentMethodNetwork"] = payment.token.paymentMethod.network

            switch payment.token.paymentMethod.type {
            case PKPaymentMethodType.unknown:
                typeCard = "unknown"
                break;
            case PKPaymentMethodType.debit:
                typeCard = "debit"
                break;
            case PKPaymentMethodType.credit:
                typeCard = "credit"
                break;
            case PKPaymentMethodType.prepaid:
                typeCard = "prepaid"
                break;
            case PKPaymentMethodType.store:
                typeCard = "store"
                break;
            }
        } else {
            typeCard = "error"
        }
        response["paymentMethodTypeCard"] = typeCard
//        if #available(iOS 9.0, *), let billingContact = payment.billingContact {
//            if let emailAddress = billingContact.emailAddress {
//                response["billingEmailAddress"] = emailAddress
//            }
//            if #available(iOS 9.2, *), let supplementarySubLocality = billingContact.supplementarySubLocality {
//                response["billingSupplementarySubLocality"] = supplementarySubLocality
//            }
//            if let name = billingContact.name {
//                if let givenName = name.givenName {
//                    response["billingNameFirst"] = givenName
//                }
//                if let middleName = name.middleName {
//                    response["billingNameMiddle"] = middleName
//                }
//                if let familyName = name.familyName {
//                    response["billingNameLast"] = familyName
//                }
//            }
//            if let postalAddress = billingContact.postalAddress {
//                response["billingAddressStreet"] = postalAddress.street
//                response["billingAddressCity"] = postalAddress.city
//                response["billingAddressState"] = postalAddress.state
//                response["billingPostalCode"] = postalAddress.postalCode
//                response["billingCountry"] = postalAddress.country
//                response["billingISOCountryCode"] = postalAddress.isoCountryCode
//            }
//
//            if let shippingContact = payment.shippingContact {
//                if let emailAddress = shippingContact.emailAddress {
//                    response["shippingEmailAddress"] = emailAddress
//                }
//                if let phoneNumber = shippingContact.phoneNumber {
//                    response["shippingPhoneNumber"] = phoneNumber.stringValue
//                }
//                if let name = shippingContact.name {
//                    if let givenName = name.givenName {
//                        response["shippingNameFirst"] = givenName
//                    }
//                    if let middleName = name.middleName {
//                        response["shippingNameMiddle"] = middleName
//                    }
//                    if let familyName = name.familyName {
//                        response["shippingNameLast"] = familyName
//                    }
//                }
//                if #available(iOS 9.2, *), let supplementarySubLocality = shippingContact.supplementarySubLocality {
//                    response["shippingSupplementarySubLocality"] = supplementarySubLocality
//                }
//                if let postalAddress = shippingContact.postalAddress {
//                    response["shippingAddressStreet"] = postalAddress.street
//                    response["shippingAddressCity"] = postalAddress.city
//                    response["shippingAddressState"] = postalAddress.state
//                    response["shippingPostalCode"] = postalAddress.postalCode
//                    response["shippingCountry"] = postalAddress.country
//                    response["shippingISOCountryCode"] = postalAddress.isoCountryCode
//                }
//            }
//
//        } else if #available(iOS 8.0, *) {
//            if let shippingAddress = payment.shippingAddress {
//
//                if let PersonAddressStreetKey = kABPersonAddressStreetKey as? ABPropertyID, let shippingAddressStreet = ABRecordCopyValue(shippingAddress, PersonAddressStreetKey).takeRetainedValue() as? String {
//                    response["shippingAddressStreet"] = shippingAddressStreet
//                }
//                if let PersonAddressCityKey = kABPersonAddressCityKey as? ABPropertyID, let shippingAddressCity = ABRecordCopyValue(shippingAddress, PersonAddressCityKey).takeRetainedValue() as? String {
//                    response["shippingAddressCity"] = shippingAddressCity
//                }
//                if let PersonAddressZIPKey = kABPersonAddressZIPKey as? ABPropertyID, let shippingPostalCode = ABRecordCopyValue(shippingAddress, PersonAddressZIPKey).takeRetainedValue() as? String {
//                    response["shippingPostalCode"] = shippingPostalCode
//                }
//                if let PersonAddressStateKey = kABPersonAddressStateKey as? ABPropertyID, let shippingAddressState = ABRecordCopyValue(shippingAddress, PersonAddressStateKey).takeRetainedValue() as? String {
//                    response["shippingAddressState"] = shippingAddressState
//                }
//                if let PersonAddressCountryCodeKey = kABPersonAddressCountryCodeKey as? ABPropertyID, let shippingCountry = ABRecordCopyValue(shippingAddress, PersonAddressCountryCodeKey).takeRetainedValue() as? String {
//                    response["shippingCountry"] = shippingCountry
//                }
//                if let PersonAddressCityKey = kABPersonAddressCityKey as? ABPropertyID, let shippingISOCountryCode = ABRecordCopyValue(shippingAddress, PersonAddressCityKey).takeRetainedValue() as? String {
//                    response["shippingISOCountryCode"] = shippingISOCountryCode
//                }
//                if let shippingEmailAddress = ABRecordCopyValue(shippingAddress, kABPersonEmailProperty).takeRetainedValue() as? String {
//                    response["shippingEmailAddress"] = shippingEmailAddress
//                }
//
//            }
//        }
        return response
    }


}



extension StripeExecutor: StripeAppleDelegate {
    func stripeAppleInitialize() {
        JJPrint("StripeExecutor stripeAppleInitialize")
        if #available(iOS 9.2, *) {
            supportedPaymentNetworks.append(PKPaymentNetwork.chinaUnionPay)
        }

//        if #available(iOS 9.0, *) {
            //merchantCapabilities.insert(.capabilityCredit)
            //merchantCapabilities.insert(.capabilityDebit)
//        }
        
        if let id = merchantIdentifier {
            STPPaymentConfiguration.shared().appleMerchantIdentifier = id;
            JJPrint("merchantIdentifier:\(id)")
        }
        
    }
    func stripeAppleMakePaymentRequest(_ body: NSDictionary, _ callback: CallbackHandler?) {
        JJPrint("StripeExecutor stripeAppleMakePaymentRequest")
        payResultCallback = callback
        makePaymentRequest(body, callback);
    }
    func stripeAppleCompleteLastTransaction(_ body: NSDictionary, _ callback: CallbackHandler?) {
        JJPrint("StripeExecutor stripeAppleCompleteLastTransaction")
        completeLastTransaction(body, callback);
    }
    
    public var options: [String: Any]? {
        set {
            JJPrint("options:\(newValue)")
            self.privateOptions = newValue;

            if let merchantIdentifier = privateOptions?["appleMerchantIdentifier"] as? String {
                self.merchantIdentifier = merchantIdentifier
            }
            
            if let stripePublishableKey = privateOptions?["stripePublishableKey"] as? String {
                self.stripePublishableKey = stripePublishableKey
            }
        }
        get {
            return privateOptions
        }
    }
    
    public var baseViewController: UIViewController? {
        set {
            JJPrint("baseViewController:\(newValue)")
            self.VC = newValue;
        }
        get {
            return VC
        }
    }
    
}

