//
//  TransactionsManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

extension TransactionsManager {
    
    enum State {
        case none
        case loading
        case finish
        case error
    }
}

extension Notification.Name {
    static let transactionManagerDidChangeRecent = Notification.Name.init(rawValue: "TransactionManagerDidChangeRecent")
}

class TransactionsManager {
    
    static let shared: TransactionsManager = .init()
    let host = ApiHostManager.baseUrl.absoluteString

    private(set) var state: State = .none
    private(set) var recentTransactions: [CompletedPayment] = []
    
    private init() {
        self.start()
    }
    
    public func start() {
        
        self.actionUpdateRecentTransactions()
    }
    
    private var recentTransactionsRequest: ApiRequest<ApiProtobufResponseModel<RecentPaymentsResponce>>?
    public func actionUpdateRecentTransactions() {
        guard self.recentTransactionsRequest == nil else {
            return
        }

        self.recentTransactionsRequest = Api.recentTransactions(host: self.host, clientId: 0, successHandler: { (response) in
            
            print("Response: \(response)")
            self.recentTransactions = response.protobufObject.payments
            self.recentTransactionsRequest = nil
        }) { (error) in
            print("Error: \(error)")
            self.recentTransactionsRequest = nil
        }
        self.recentTransactionsRequest?.start()
    }
    
}
