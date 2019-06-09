//
//  PaymentViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    @IBOutlet var qrImageView: UIImageView!
//    @IBOutlet var qrImageView: UIImageView!

    var payment: CompletedPayment!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Электронный чек"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.parent == self.navigationController {
            self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
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
