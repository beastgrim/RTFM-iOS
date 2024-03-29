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
    
    class func userInfo<T: ApiProtobufResponseModel<UserInfoResponse>>(host: String, clientId: Int64, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = UserInfoRequest()
        payload.clientID = clientId
        
        let request = ApiRequest(protobufToHost: host, path: "api/user_info",
                                 uniqueType: "user_info",
                                 protobufRequest: payload, successHandler: successHandler,
                                 failureHandler: { (error) in
                                    
                                    Api.record(error: error)
                                    failureHandler(error)
        })
        request.attemptWaitSeconds = 0
        request.maxAttempts = 1
        return request
    }
    
    class func recentTransactions<T: ApiProtobufResponseModel<RecentPaymentsResponce>>(host: String, clientId: Int64, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = RecentPaymentsRequest()
        payload.clientID = clientId

        let request = ApiRequest(protobufToHost: host, path: "api/recent_payments",
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
    
    class func rechargeTransaction<T: ApiProtobufResponseModel<ApiSuccessEmptyResponse>>(host: String, clientId: Int64, amount: Int32, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = RefilRequest()
        payload.clientID = clientId
        payload.value = amount
        
        let request = ApiRequest(protobufToHost: host, path: "api/refil",
                                 uniqueType: "refil",
                                 protobufRequest: payload, successHandler: successHandler,
                                 failureHandler: { (error) in
                                    
                                    Api.record(error: error)
                                    failureHandler(error)
        })
        request.attemptWaitSeconds = 0
        request.maxAttempts = 1
        return request
    }
    
    class func completeTransaction<T: ApiProtobufResponseModel<ApiSuccessEmptyResponse>>(host: String, clientId: Int64, transactionId: Int64, transportId: Int64, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = Payment()
        payload.clientID = clientId
        payload.transactionID = transactionId
        payload.transportID = transportId
        
        let request = ApiRequest(protobufToHost: host, path: "api/transact",
                                 uniqueType: "transact",
                                 protobufRequest: payload, successHandler: successHandler,
                                 failureHandler: { (error) in
                                    
                                    Api.record(error: error)
                                    failureHandler(error)
        })
        request.attemptWaitSeconds = 0
        request.maxAttempts = 1
        return request
    }
    
    class func ticketPrice<T: ApiProtobufResponseModel<GetPriceResponse>>(host: String, clientId: Int64, transportId: Int32, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void)) -> ApiRequest<T> {
        
        var payload = GetPriceRequest()
        payload.transportID = transportId
        
        let request = ApiRequest(protobufToHost: host, path: "api/price",
                                 uniqueType: "price",
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
