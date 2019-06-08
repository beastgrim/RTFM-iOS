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

class TransactionsManager {
    
    static let shared: TransactionsManager = .init()
    private(set) var state: State = .none
    
    private init() {
        self.start()
    }
    
    public func start() {
        let host = ApiHostManager.baseUrl.absoluteString
        
        let request = Api.recentTransactions(host: host, clientId: 0, successHandler: { (response) in
        
            print("Response: \(response)")
        }) { (error) in
            print("Error: \(error)")
        }
        request.start()
    }
    
}
