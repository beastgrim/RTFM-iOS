//
//  ViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import Alamofire

class HeaderButton: UIButton {
    
    var maxWidth: CGFloat = 0.0
    var backgorundImageSize: CGSize = .zero
    var imageTextPadding: CGFloat = 3.0
    var maxFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 2
    }
    
    override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        super.setBackgroundImage(image, for: state)
        if let size = image?.size {
            self.backgorundImageSize = size
        }
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageSize = self.backgorundImageSize
        
        var result = contentRect
        result.origin.y = ceil(imageSize.height+self.imageTextPadding)
        result.size.height -= result.origin.y
        
        return result
    }
    
    override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        var result = bounds
        if bounds.size.width >= self.backgorundImageSize.width &&
            bounds.size.height >= self.backgorundImageSize.height {
            
            result.size = self.backgorundImageSize
            result.origin.x = (bounds.width - self.backgorundImageSize.width)*0.5
        }
        return result
    }
    
    override var intrinsicContentSize: CGSize {
        var titleSize = self.titleLabel?.sizeThatFits(.zero) ?? .zero
        titleSize.height = CGFloat(self.titleLabel?.numberOfLines ?? 1) * (self.titleLabel?.font.lineHeight ?? 15)
        if let title = self.titleLabel?.text {
            let size = (title as NSString).size(withAttributes: [.font: self.maxFont])
            titleSize.width = max(titleSize.width, size.width)
            titleSize.height = max(titleSize.height, size.height)
        }
        let imageSize = self.backgorundImageSize
        let contentInset = self.contentEdgeInsets
        var width = ceil(max(titleSize.width, imageSize.width) + contentInset.left + contentInset.right)
        if self.maxWidth > 0.0, width > self.maxWidth {
            width = self.maxWidth
        }
        let height = ceil(imageSize.height + self.imageTextPadding + titleSize.height + contentInset.top + contentInset.bottom)
        
        return CGSize(width: width, height: height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
}

class HeaderView: UIView {
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1
            self.titleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            self.titleLabel.font = UIFont(name: "Sarabun-Medium", size: 16)
            self.titleLabel.attributedText = NSMutableAttributedString(string: "Текущий баланс", attributes: [.paragraphStyle: paragraphStyle])
        }
    }
    @IBOutlet var moneyLabel: UILabel! {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            self.moneyLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            self.moneyLabel.font = UIFont(name: "Sarabun-Bold", size: 40)
            self.moneyLabel.attributedText = NSMutableAttributedString(string: "1500.00", attributes: [.paragraphStyle: paragraphStyle])
        }
    }
    @IBOutlet var addButton: UIButton! {
        didSet {
            self.addButton.setBackgroundImage(UIImage(named: "add"), for: .normal)
        }
    }
    @IBOutlet var historyButton: UIButton! {
        didSet {
            self.historyButton.setBackgroundImage(UIImage(named: "history"), for: .normal)
        }
    }
}

class MainViewController: UIViewController {
    
    let transactionManager: TransactionsManager = .shared
    
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var transactionsTitleLabel: UILabel! {
        didSet {
            self.transactionsTitleLabel.textColor = UIColor(red: 0.23, green: 0.25, blue: 0.29, alpha: 1)
            self.transactionsTitleLabel.font = UIFont(name: "Sarabun-SemiBold", size: 18)
        }
    }
    @IBOutlet var payButton: UIButton! {
        didSet {
            self.payButton.titleLabel?.font = UIFont(name: "Sarabun-SemiBold", size: 16)
            self.payButton.titleLabel?.textColor = .white
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Мой кошелек"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "Мой кошелек"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logout = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(actionLogout(_:)))
        logout.tintColor = .white
        self.navigationItem.rightBarButtonItem = logout
        
        self.actionReloadUserInfo()
        
        self.observer = NotificationCenter.default.addObserver(forName: .transactionManagerDidUserInfo, object: nil, queue: .main) { (_) in
            
            self.actionReloadUserInfo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    deinit {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Public
    
    @IBAction @objc public func actionStartPayment(_ sender: Any?) {
        let scanner = QRScannerViewController.newScanner()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
        
        Alamofire.request("http://192.168.47.69:8080/api/recent_payments/").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    public func actionGenerateQRCodeForPay() {
        guard let transportId = self.transportId else {
            return
        }
        print("QR code: \(transportId)")
    }
    
    @objc public func actionLogout(_ sender: Any?) {
        // TODO: Show login page
    }
    
    public func actionUpdateUserInfo() {
        self.transactionManager.actionUpdateRecentTransactions()
    }
    
    public func actionReloadUserInfo() {
        if let balance = self.transactionManager.userInfo?.balance {
            self.headerView.moneyLabel.text = balance
            self.headerView.activity.stopAnimating()
            self.headerView.titleLabel.text = "Текущий баланс"
        } else {
            self.headerView.activity.startAnimating()
            self.headerView.moneyLabel.text = ""
            self.headerView.titleLabel.text = ""
        }
    }
    
    @IBAction @objc public func actionShowHistory(_ sender: Any?) {
        let transactions = TransactionsViewController.newTransactions()
        transactions.title = "История транзакций"
        self.navigationController?.pushViewController(transactions, animated: true)
    }
    
    @IBAction @objc public func actiona(_ sender: Any?) {
        let transactions = TransactionsViewController.newTransactions()
        transactions.title = "История транзакций"
        self.navigationController?.pushViewController(transactions, animated: true)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let transaction = segue.destination as? TransactionsViewController {
            self.transactionsViewController = transaction
        }
    }
    
    // MARK: - Private
    private var observer: AnyObject?
    private weak var transactionsViewController: TransactionsViewController!
    private var transportId: String?
}

extension MainViewController: QRScannerViewControllerDelegate {
    
    func qrScanner(_ viewController: QRScannerViewController, didScan object: String) {
        self.transportId = object
        viewController.dismiss(animated: true) {
            self.actionGenerateQRCodeForPay()
        }
    }
}

