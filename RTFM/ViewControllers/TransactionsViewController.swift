//
//  TransactionsViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    static let id = "TransactionCell"
    
    @IBOutlet var roundedView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    
    lazy private var shadowLayer: CALayer = {
       let layer = CALayer()
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contentView.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundedView.layer.cornerRadius = 10
        self.roundedView.clipsToBounds = true
        
        self.amountLabel.textColor = UIColor(red: 0.73, green: 0.42, blue: 0.85, alpha: 1)
        self.amountLabel.font = UIFont(name: "Sarabun-SemiBold", size: 16)
        
        self.titleLabel.textColor = UIColor(red: 0.09, green: 0.11, blue: 0.2, alpha: 1)
        self.titleLabel.font = UIFont(name: "Sarabun-Regular", size: 12)
        
        self.descLabel.textColor = UIColor(red: 0.46, green: 0.5, blue: 0.55, alpha: 1)
        self.descLabel.font = UIFont(name: "Sarabun-Regular", size: 12)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowLayer.frame = self.contentView.bounds
        self.shadowLayer.shadowPath = UIBezierPath(roundedRect: self.roundedView.frame, cornerRadius: 10).cgPath
    }
}

class TransactionsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.id, for: indexPath) as! TransactionCell

        return cell
    }

    /*
    // Override to ssupport conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
