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

    //@objc optional func otherFunction() //optional
}


@objc public class OrderPlace: NSObject {

    static weak var OPDelegate: OrderPlaceDelegate?

    public static func makeViewController(vcId: String) -> UIViewController {

        let podBundle = Bundle(for: OrderPlace.self)

        print("podBundle", podBundle.bundlePath)

        // old
        //let bundleURL = podBundle.url(forResource: "OrderPlaceSdk", withExtension: "bundle")

        // jadd
        let bundleURL = podBundle.url(forResource: "OrderPlaceSDK", withExtension: "framework")

        var bundle = podBundle

        if(bundleURL != nil) {
            bundle = Bundle(url: bundleURL!)!
        }

        let storyboard = UIStoryboard(name: "OrderPlaceStoryboard", bundle: bundle)

        print("storyboard", storyboard)

        let controller = storyboard.instantiateViewController(withIdentifier: vcId);


        return controller;

    }

    @objc public class func openUrl(caller: UIViewController, url: String, options: [String: Any]) {

        print("open url")
        let controller = makeViewController(vcId: "OrderViewControllerNav") as! UINavigationController;

        let orderVC = controller.topViewController as! OrderViewController;

        orderVC.url = url;
        orderVC.options = options;
        self.OPDelegate = orderVC

        caller.present(controller, animated: true, completion: nil)

    }

    @objc public class func openUrl(caller: UIViewController, url: String, options: [String: Any], services: Array<OrderPlaceService>) {

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

    @objc public class func scan(caller: UIViewController, options: [String: Any]) {

        let controller = makeViewController(vcId: "ScannerViewControllerNav") as! UINavigationController;

        let scanVC = controller.topViewController as! ScannerViewController;

        scanVC.options = options;

        caller.present(controller, animated: true, completion: nil)

    }

    @objc public class func application(_ app: UIApplication, open url: URL) {
        if let del = OPDelegate {
            del.applicationOpenUrl(app, url: url)
        }
    }


}
