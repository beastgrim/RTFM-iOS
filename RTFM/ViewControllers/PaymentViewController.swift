//
//  PaymentViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import EFQRCode

class PaymentViewController: UIViewController {
    @IBOutlet var qrImageView: UIImageView!
//    @IBOutlet var qrImageView: UIImageView!

    var payment: CompletedPayment!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Электронный чек"
        
        let code = String(TransactionsManager.shared.clientId)
        QRCodeManager.generateQRCode(string: code) { (image) in
            self.qrImageView.image = image
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
