//
//  Api.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Api {
    class func record(error: ApiRequestError) {
        // TODO:
    }
    
    class func recentTransactions<T: ApiProtobufResponseModel<ApiSuccessEmptyResponse>>(host: String, clientId: Int64, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = Transaction()
        // TODO: 
        let request = ApiRequest(protobufToHost: host, path: "api/recent_transactions",
                                 uniqueType: "recent_transactions",
                                 protobufRequest: payload, successHandler: successHandler,
                                 failureHandler: { (error) in
                                    
                                    Api.record(error: error)
                                    failureHandler(error)
        })
        request.attemptWaitSeconds = 0
        request.maxAttempts = 1
        return request
    }
}