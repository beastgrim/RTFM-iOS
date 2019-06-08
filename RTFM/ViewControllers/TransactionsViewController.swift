//
//  TransactionsViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import CoreData

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
    
    class func newTransactions() -> QRScannerViewController {
        let vc: QRScannerViewController = UIStoryboard.viewController()
        return vc
    }
    
    let transactionManager: TransactionsManager = .shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
        
        self.observer = NotificationCenter.default.addObserver(forName: .transactionManagerDidChangeRecent, object: nil, queue: .main, using: { (note) in
            
            self.reloadData()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Private
    private var days: [DayPayments] = []
    private var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        return df
    }()
    private var observer: AnyObject?
    
    private func actionUpdateData() {
        self.transactionManager.actionUpdateRecentTransactions()
    }
    
    private func reloadData() {
        self.days = DayPayments.parsePayments(self.transactionManager.recentTransactions)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.days.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days[section].payments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let payment: CompletedPayment = self.days[indexPath.section].payments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.id, for: indexPath) as! TransactionCell

        let date = Date(timeIntervalSince1970: TimeInterval(payment.date))
        cell.titleLabel.text = payment.title
        cell.amountLabel.text = payment.price
        cell.descLabel.text = self.dateFormatter.string(from: date)
        var icon: UIImage!
        
        switch payment.type {
        case .bus:
            icon = UIImage(named: "bus")!
        case .mt:
            icon = UIImage(named: "taxi")!
        case .taxy:
            icon = UIImage(named: "taxi")!
        case .subway:
            icon = UIImage(named: "metro")!

        @unknown default: break
        }
        cell.iconView.image = icon
        return cell
    }
}

extension TransactionsViewController: NSFetchedResultsControllerDelegate {
    
}
