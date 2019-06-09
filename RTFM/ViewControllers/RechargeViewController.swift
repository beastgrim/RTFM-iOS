//
//  RechargeViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import MBProgressHUD

class PaySourceCollectionViewCell: UICollectionViewCell {
    @IBOutlet var shadowView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
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
        
        self.shadowView.layer.cornerRadius = 10
        self.shadowView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowLayer.frame = self.contentView.bounds
        self.shadowLayer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds.insetBy(dx: 8, dy: 8), cornerRadius: 10).cgPath
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                let col = self.isSelected ? UIColor.red.withAlphaComponent(0.5) : UIColor.white
                self.shadowView.backgroundColor = col
            }
        }
    }
}

class PaymentSourceViewModel {
    var id: Int
    var icon: UIImage
    var title: String
    
    init(id: Int, icon: UIImage, title: String) {
        self.id = id
        self.icon = icon
        self.title = title
    }
}

class RechargeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let manager = TransactionsManager.shared
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    @IBOutlet var inputContainerView: UIView!
    @IBOutlet var payButton: UIButton!

    private(set) var paymentsSources: [PaymentSourceViewModel] = []
    private(set) var selectedPayment: PaymentSourceViewModel? {
        didSet { self.payButton?.isEnabled = self.selectedPayment != nil }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Пополнение"
        self.selectedPayment = nil
        
        var payments = [PaymentSourceViewModel]()
        payments.append(PaymentSourceViewModel(id: 0, icon: UIImage(named: "phone-ic")!, title: "По номеру".uppercased()))
        payments.append(PaymentSourceViewModel(id: 1, icon: UIImage(named: "sms-ic")!, title: "По СМС".uppercased()))
        payments.append(PaymentSourceViewModel(id: 2, icon: UIImage(named: "paypal-ic")!, title: "Paypal".uppercased()))
        payments.append(PaymentSourceViewModel(id: 3, icon: UIImage(named: "sber-ic")!, title: "Сбербанк".uppercased()))

        self.paymentsSources = payments
        
        self.observer = NotificationCenter.default.addObserver(forName: .transactionManagerDidRefill, object: nil, queue: .main) { (_) in
            
            self.actionFinishRefill()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self.observer!)
    }
    
    @IBAction @objc public func actionRefill(_ sender: Any?) {
        self.payButton.isEnabled = false
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.manager.actionRefill(amount: 4000, completion: { err in
            if err == nil {
                self.actionFinishRefill()
            } else {
                // TODO: show error
            }
        })
    }
    
    private func actionFinishRefill() {
        self.payButton.isEnabled = true
        MBProgressHUD.hide(for: self.view, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    private var observer: AnyObject!

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.paymentsSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paySource = self.paymentsSources[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paySource", for: indexPath) as! PaySourceCollectionViewCell
        cell.iconImageView.image = paySource.icon
        cell.titleLabel.text = paySource.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let paySource = self.paymentsSources[indexPath.row]
        self.selectedPayment = paySource
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutSubviews()
    }

}
