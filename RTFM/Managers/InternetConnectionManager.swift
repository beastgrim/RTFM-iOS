//
//  InternetConnectionManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import CocoaLumberjack

extension Notification.Name {
    static let internetReachabilityChanged = Notification.Name("internetReachabilityChanged")
}

class InternetConnectionManager: NSObject {
    
    static let shared: InternetConnectionManager = {
        let instance = InternetConnectionManager()
        return instance
    }()
    
    fileprivate var reach: Reachability!
    
    var isReachable: Bool {
        if self.reach.currentReachabilityStatus() != NotReachable {
            return true
        }
        return false
    }
    
    var isReachableViaWiFi: Bool {
        return self.reach.currentReachabilityStatus() == ReachableViaWiFi
    }
    
    override init() {
        super.init()

        self.reach = Reachability.forInternetConnection()
        self.start()
    }
    
    public func start() {
        guard let reach = self.reach else { return }
        
        reach.startNotifier()
        reach.reachabilityChanged = { (networkStatus) in
            let isReachable = networkStatus != NotReachable
            DDLogInfo("[InternetConnection] \((isReachable ? "reachable" : "unreachable"))")
            NotificationCenter.default.post(name: .internetReachabilityChanged, object: self)
        }
        
        DDLogInfo("[InternetConnection] start \(self.reach.currentReachabilityStatus() != NotReachable ? "reachable" : "unreachable")")
    }
}
