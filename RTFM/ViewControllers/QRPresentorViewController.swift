//
//  QRPresentorViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class QRPresentorViewController: UIViewController {
    
    class func newPresentor() -> QRPresentorViewController {
        return UIStoryboard.viewController()
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cancelButton: UIButton!

    public var code: String? {
        didSet {
            if let code = self.code {
                Queue.parse.async {
                    let qrCodeImage = QRCodeManager.generateQRCode(string: code)
                    Queue.main.async {
                        self.imageView.image = qrCodeImage
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction @objc public func actionClose(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }

}
