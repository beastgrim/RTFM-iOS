//
//  QRPresentorViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import MBProgressHUD

struct TicketInfo {
    var transactionId: Int64
    var transportId: Int64
}

class QRPresentorViewController: UIViewController {
    
    let manager = TransactionsManager.shared
    class func newPresentor() -> QRPresentorViewController {
        return UIStoryboard.viewController()
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var payButton: UIButton!

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
    
    @IBAction @objc public func actionPayOnline(_ sender: Any?) {
        guard let code = self.code else { return }
        
        guard let ticket = self.parseQRCode(code) else { return }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.manager.actionBuyTicket(transactionId: ticket.transactionId, transportId: ticket.transportId) { (error) in
            
            if let error = error {
                // TODO: show error
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: - Private
    
    private func parseQRCode(_ code: String) -> TicketInfo? {
        // TODO: parse QR code
        return TicketInfo(transactionId: 1, transportId: 2)
    }

}
