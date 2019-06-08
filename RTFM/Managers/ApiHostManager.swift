//
//  ApiHostManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import Alamofire

class ApiHostManager {
    
    static let baseUrl: URL = URL(string: "http://ec2-3-82-45-111.compute-1.amazonaws.com:8080/")!

    static let operationSession: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        
        let session = SessionManager(configuration: configuration)
        session.startRequestsImmediately = false
        
        return session
    }()
}
