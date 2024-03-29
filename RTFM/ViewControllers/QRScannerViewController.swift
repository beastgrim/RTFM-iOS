//
//  QRScannerViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRScannerViewControllerDelegate: AnyObject {
    func qrScanner(_ viewController: QRScannerViewController, didScan object: String)
}

class QRScannerViewController: UIViewController {
    
    public var useFrontCamera: Bool = false
    @IBOutlet var targetImageView: UIImageView!
    @IBOutlet var closeButton: UIButton!

    static let session: AVCaptureSession = {
        func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
            let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            for device in discoverySession.devices {
                if device.position == position {
                    return device
                }
            }
            return nil
        }
        
        let session = AVCaptureSession()
        let device = AVCaptureDevice.default(for: .video)!
        let camera = cameraWithPosition(position: .back)!
        let input = try! AVCaptureDeviceInput.init(device: camera)
        session.addInput(input)
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        return session
    }()
    
    weak var delegate: QRScannerViewControllerDelegate?
    class func newScanner() -> QRScannerViewController {
        let vc: QRScannerViewController = UIStoryboard.viewController()
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupScanner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.actionStartScan()
    }
    
    public func actionStartScan() {
        self.session?.startRunning()
    }
    
    @IBAction @objc public func actionClose(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    private var device: AVCaptureDevice!
    private var input: AVCaptureDeviceInput!
    private var session: AVCaptureSession!
    private var output: AVCaptureMetadataOutput!
    private var preview: AVCaptureVideoPreviewLayer!
    
    private func setupScanner() {
        self.session = QRScannerViewController.session
        self.output = self.session.outputs.first! as? AVCaptureMetadataOutput
        
        self.output.setMetadataObjectsDelegate(self, queue: .main)
        self.output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        self.preview = AVCaptureVideoPreviewLayer(session: self.session)
        self.preview.videoGravity = .resizeAspectFill
        self.preview.frame = self.view.bounds
        
        let con = self.preview.connection
        con?.videoOrientation = .portrait
        
        self.view.layer.insertSublayer(self.preview, at: 0)
    }

    private func didScanObject(_ object: AVMetadataMachineReadableCodeObject) {
        
        if let value = object.stringValue {
            self.session.stopRunning()
            self.delegate?.qrScanner(self, didScan: value)
        }
    }
    
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for obj in metadataObjects where obj.type == .qr {
            if let codeObject = obj as? AVMetadataMachineReadableCodeObject {
                self.didScanObject(codeObject)
                return
            }
        }
    }
}
