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
    var price: String?
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
        self.ticket = ticket
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getPrice()
  
    }
    
    private func actionPayOnlineFinish(error: Error?) {
        MBProgressHUD.hide(for: self.view, animated: true)

    }
    
    private func actionShowPrice() {
        
    }
    
    // MARK: - Private
    private var ticket: TicketInfo?
    
    private func parseQRCode(_ code: String) -> TicketInfo? {
        // TODO: parse QR code
        return TicketInfo(transactionId: 1, transportId: 7, price: nil)
    }
    
    private func payOnline() {
        guard let ticket = self.ticket else { return }

        self.manager.actionBuyTicket(transactionId: ticket.transactionId, transportId: ticket.transportId) { (error) in
            
            self.actionPayOnlineFinish(error: error)
        }
    }

    private func getPrice() {
        guard let ticket = self.ticket else { return }
        self.manager.actionGetTicketPrice(ticket: ticket) { (price, error) in
            if let price = price {
                self.ticket?.price = price.price
                self.actionShowPrice()
            } else {
                self.actionPayOnlineFinish(error: error)
            }
        }
    }
}
