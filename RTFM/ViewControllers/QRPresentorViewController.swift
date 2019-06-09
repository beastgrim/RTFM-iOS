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
    var paid: Bool = false
}

class QRPresentorPriceView: UIView {
    @IBOutlet var titleLabel: UILabel!
}

class QRPresentorViewController: UIViewController {
    
    let manager = TransactionsManager.shared
    class func newPresentor() -> QRPresentorViewController {
        return UIStoryboard.viewController()
    }
    
    @IBOutlet var priceView: QRPresentorPriceView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var payButton: UIButton!

    public var code: String? {
        didSet {
            if let code = self.code {
                QRCodeManager.generateQRCode(string: code) { (image) in
                    self.imageView.image = image
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceView.isHidden = true
        self.payButton.isEnabled = false
        
        if let code = self.code {
            self.ticket = self.parseQRCode(code)
            self.getPrice()
        }
    }
    
    // MARK: - Actions
    
    @IBAction @objc public func actionClose(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction @objc public func actionPayOnline(_ sender: Any?) {
        guard self.ticket != nil else { return }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.payOnline()
    }
    
    private func actionPayOnlineFinish(error: Error?) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let _ = error {
            // TODO: Show error
        } else {
            self.ticket?.paid = true
            self.payButton.isHidden = true
            
            self.manager.actionUpdateUserInfo()
            self.manager.actionUpdateRecentTransactions()
        }
    }
    
    private func actionShowPrice() {
        guard let price = self.ticket?.price else { return }

        self.priceView.isHidden = false
        self.priceView.titleLabel.text = price
        self.payButton.isEnabled = true
    }
    
    // MARK: - Private
    private var ticket: TicketInfo?
    
    private func parseQRCode(_ code: String) -> TicketInfo? {
        // TODO: parse QR code
        return TicketInfo(transactionId: Int64(arc4random()), transportId: 7, price: nil, paid: false)
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
