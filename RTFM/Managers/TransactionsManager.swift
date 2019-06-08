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
    static let transactionManagerDidUserInfo = Notification.Name.init(rawValue: "transactionManagerDidUserInfo")

}

class TransactionsManager {
    
    static let shared: TransactionsManager = .init()
    let host = ApiHostManager.baseUrl.absoluteString

    private(set) var clientId: Int64 = 1
    private(set) var state: State = .none
    private(set) var recentTransactions: [CompletedPayment] = []
    private(set) var userInfo: UserInfoResponse?
    
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

        self.recentTransactionsRequest = Api.recentTransactions(host: self.host, clientId: self.clientId, successHandler: { (response) in
            
            print("Payments: \(response.protobufObject.payments)")
            self.recentTransactions = response.protobufObject.payments
            self.recentTransactionsRequest = nil
            NotificationCenter.default.post(name: .transactionManagerDidChangeRecent, object: self)
        }) { (error) in
            print("Error: \(error)")
            self.recentTransactionsRequest = nil
        }
        self.recentTransactionsRequest?.start()
    }
    
    private var userInfoRequest: ApiRequest<ApiProtobufResponseModel<UserInfoResponse>>?
    public func actionUpdateUserInfo() {
        guard self.userInfoRequest == nil else {
            return
        }
        
        self.userInfoRequest = Api.userInfo(host: self.host, clientId: self.clientId, successHandler: { (response) in
            
            print("Response: \(response)")
            let userInfo = response.protobufObject
            self.userInfoRequest = nil
            if self.userInfo != userInfo {
                self.userInfo = userInfo
                NotificationCenter.default.post(name: .transactionManagerDidUserInfo, object: self)
            }
        }, failureHandler: { (error) in
            print("Error: \(error)")
            self.userInfoRequest = nil
        })
    }
}
