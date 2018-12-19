//
//  OrderPlace.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 2/9/2018.
//

import Foundation
import UIKit


protocol OrderPlaceDelegate: AnyObject {

    func applicationOpenUrl(_ app: UIApplication, url: URL)
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
    //@objc optional func otherFunction() //optional
}


@objc public class OrderPlace: NSObject {

    static weak var OPDelegate: OrderPlaceDelegate?

    public static func makeViewController(vcId: String) -> UIViewController {

        let podBundle = Bundle(for: OrderPlace.self)

        print("podBundle", podBundle.bundlePath)

        let bundleURL = podBundle.url(forResource: "OrderPlaceSdk", withExtension: "bundle")

        var bundle = podBundle

        if(bundleURL != nil) {
            bundle = Bundle(url: bundleURL!)!
        }

        let storyboard = UIStoryboard(name: "OrderPlaceStoryboard", bundle: bundle)

        print("storyboard", storyboard)

        let controller = storyboard.instantiateViewController(withIdentifier: vcId);


        return controller;

    }

    @objc public static func openUrl(caller: UIViewController, url: String, options: [String: Any]) {

        print("open url")
        let controller = makeViewController(vcId: "OrderViewControllerNav") as! UINavigationController;

        let orderVC = controller.topViewController as! OrderViewController;

        orderVC.url = url;
        orderVC.options = options;
        self.OPDelegate = orderVC

        caller.present(controller, animated: true, completion: nil)

    }

    @objc public static func openUrl(caller: UIViewController, url: String, options: [String: Any], services: Array<OrderPlaceService>) {

        print("open url")

        let controller = makeViewController(vcId: "OrderViewControllerNav") as! UINavigationController;

        let orderVC = controller.topViewController as! OrderViewController;
        orderVC.url = url;
        orderVC.options = options;
        orderVC.extraServices = services;
        self.OPDelegate = orderVC

        caller.present(controller, animated: true, completion: nil)

        openUrl(caller: caller, url: url, options: options)

    }

    @objc public static func scan(caller: UIViewController, options: [String: Any]) {

        let controller = makeViewController(vcId: "ScannerViewControllerNav") as! UINavigationController;

        let scanVC = controller.topViewController as! ScannerViewController;
        scanVC.options = options;
        self.OPDelegate = ScannerManager.shared;
        caller.present(controller, animated: true, completion: nil)

    }

    @objc public static func application(_ app: UIApplication, open url: URL) {
        if let del = OPDelegate {
            del.applicationOpenUrl(app, url: url)
        }
    }

//    @objc public static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {

//        if let dictArray = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [Dictionary<String, Any>] {
//            for dicts in dictArray {
//                if let dict = dicts["CFBundleURLName"] as? String, dict == "weixin", let arrayCFBundleURLSchemes = dicts["CFBundleURLSchemes"] as? [String], let weixinURLSchemes = arrayCFBundleURLSchemes.first {
//
//                    WXApi.registerApp(weixinURLSchemes, enableMTA: true)
//                    //print("weixinURLSchemes:\(weixinURLSchemes)")
//                    break;
//                }
//
//            }
//        }

//    }


}
