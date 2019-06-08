//
//  ApiRequestsQueueManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

class ApiRequestsQueueManager: NSObject {
    
    fileprivate var queue = [NSObject]()
    
    static let shared: ApiRequestsQueueManager = {
        let instance = ApiRequestsQueueManager()
        return instance
    }()
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(sender:)), name: .internetReachabilityChanged, object: nil)
    }
    
    public func add(request: ApiRequestProtocol) {
        self.remove(request: request)
        
        guard let object = request as? NSObject else {
            return
        }
        self.queue.append(object)
    }
    
    public func remove(request: ApiRequestProtocol) {
        guard let object = request as? NSObject else {
            return
        }
        if let index = self.queue.firstIndex(of: object) {
            self.queue.remove(at: index)
        }
    }
    
    @objc internal func reachabilityChanged(sender: Notification) {
        if InternetConnectionManager.shared.isReachable {
            for object in self.queue {
                if let request = object as? ApiRequestProtocol {
                    request.resumeAfterInternetConnection()
                }
            }
        }
    }
    
}
