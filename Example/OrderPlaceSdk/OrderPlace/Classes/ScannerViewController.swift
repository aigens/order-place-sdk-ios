//
//  ScannerViewController.swift
//  OrderPlaceSdk
//
//  Created by Peter Liu on 7/9/2018.
//

import Foundation
import AVFoundation
import UIKit

protocol ScannerViewDelegate :AnyObject{
    
    func scannerReulst(result: String)
    //@objc optional func clicked() //optional
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var SVDelegate: ScannerViewDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var options: [String:Any]!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.backgroundColor = UIColor.clear
        
        if (navigationController != nil) {
            navigationController?.delegate = self;
        }
        
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.pdf417]
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        //view.layer.addSublayer(previewLayer);
        view.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning();
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        print("exit clicked2")
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true)
    }
    
    func failed() {
        
        print("failed")
        
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    /*
     Obselete code copied from https://stackoverflow.com/questions/46011211/barcode-on-swift-4
     
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue!);
        }
        
        dismiss(animated: true)
    }*/
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        print("metadataOutput")
        
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue!);
        }
        
        //dismiss(animated: true)
    }

    
    
    func found(code: String) {
        print(code)
        
        if (SVDelegate != nil) {
            SVDelegate?.scannerReulst(result: code)
        }
        
        if(code.starts(with: "http")) {
            self.url = code
            self.performSegue(withIdentifier: "Scan2Order", sender: self)
        } else {
            
            if (SVDelegate != nil) {
                SVDelegate?.scannerReulst(result: "Scanning error format")
            }
            dismiss(animated: true, completion: nil)
        }
        
        //orderVC.url = url;
        //orderVC.features = features;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if(self.url == nil){
            return
        }
        
        if segue.identifier == "Scan2Order" {
            let controller = segue.destination as! OrderViewController
            controller.url = self.url
            controller.options = self.options
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ScannerViewController : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        let isHidden = viewController.isKind(of: ScannerViewController.self)
        ///print("viewController: \(viewController) \(isHidden)")
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }
}
