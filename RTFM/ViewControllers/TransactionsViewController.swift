//
//  TransactionsViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import CoreData

class TransactionHeader: UITableViewHeaderFooterView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.font = UIFont(name: "Sarabun-Medium", size: 12)!
        self.textLabel?.textColor = UIColor(red: 0.46, green: 0.5, blue: 0.55, alpha: 1)
        self.contentView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds.insetBy(dx: 8, dy: 0)
    }
}

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
        self.amountLabel.font = UIFont(name: "Sarabun-SemiBold", size: 16)!
        
        self.titleLabel.textColor = UIColor(red: 0.09, green: 0.11, blue: 0.2, alpha: 1)
        self.titleLabel.font = UIFont(name: "Sarabun", size: 12)!
        
        self.descLabel.textColor = UIColor(red: 0.46, green: 0.5, blue: 0.55, alpha: 1)
        self.descLabel.font = UIFont(name: "Sarabun", size: 12)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowLayer.frame = self.contentView.bounds
        self.shadowLayer.shadowPath = UIBezierPath(roundedRect: self.roundedView.frame, cornerRadius: 10).cgPath
    }
}

class TransactionsViewController: UITableViewController {
    
    class func newTransactions() -> TransactionsViewController {
        return UIStoryboard.viewController()
    }
    
    let transactionManager: TransactionsManager = .shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.parent == self.navigationController {
            self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.register(TransactionHeader.self, forHeaderFooterViewReuseIdentifier: "header")
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
    private var cellDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    private var headerDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    private var observer: AnyObject?
    private var todayTimeStamp: TimeInterval = {
        let date = Calendar.current.startOfDay(for: Date())
        return date.timeIntervalSince1970
    }()
    
    private func actionUpdateData() {
        self.transactionManager.actionUpdateRecentTransactions()
    }
    
    private func reloadData() {
        self.days = DayPayments.parsePayments(self.transactionManager.recentTransactions)
        
        /* Debug
        var pay = CompletedPayment()
        pay.price = "40"
        pay.title = "Bus 386"
        self.days = [DayPayments(date: Date(), payments: [pay])] */
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.days.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days[section].payments.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = self.days[section].date
        let interval = date.timeIntervalSince1970
        if interval == self.todayTimeStamp {
            return "Сегодня"
        }  else if interval == self.todayTimeStamp-3600*24 {
            return "Вчера"
        }
        return self.headerDateFormatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TransactionHeader
        header.textLabel?.text = self.tableView(tableView, titleForHeaderInSection: section)
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let payment: CompletedPayment = self.days[indexPath.section].payments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.id, for: indexPath) as! TransactionCell

        let date = Date(timeIntervalSince1970: TimeInterval(payment.date))
        cell.titleLabel.text = payment.title
        cell.amountLabel.text = payment.price
        cell.descLabel.text = self.cellDateFormatter.string(from: date)
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
            
        case .UNRECOGNIZED(_): break
        }
        cell.iconView.image = icon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payment: CompletedPayment = self.days[indexPath.section].payments[indexPath.row]
        
        let controller: PaymentViewController = UIStoryboard.viewController()
        controller.payment = payment
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension TransactionsViewController: NSFetchedResultsControllerDelegate {
    
}
