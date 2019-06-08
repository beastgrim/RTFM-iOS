//
//  ApiRequest.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit
import Alamofire
import SwiftProtobuf
import CocoaLumberjack

enum ApiRequestType {
    case json
    case multipart
    case protobuf
}

protocol ApiRequestProtocol {
    var host: String { get }
    var urlString: String { get }
    
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
    var type: ApiRequestType { get }
    
    var isEncrypted: Bool { get }
    var isNeedsToBeGzipped: Bool { get }
    
    var requestHeaders: [String: String] { get }
    
    var protobufRequest: SwiftProtobuf.Message? { get }
    
    var multipartFormData: ((MultipartFormData) -> Void)? { get }
    
    var maxAttempts: Int { get set }
    
    func start()
    func resumeAfterInternetConnection()
    func cancel()
}

class ApiRequestError: BaseError<ApiRequestError.Code> {
    enum Code: Int, BaseErrorCode {
        case requestError
        case responseNotFoundError
        case responseDecryptError
        case responseParseError
        case responseStatusCodeError
        case connectionError
        case serverError
    }
    
    enum Property: String {
        case host
        case method
        case errorCode = "error_code"
        case httpCode = "http_сode"
    }
    
    override var domainShortname: String {
        return "AP"
    }
    
    override var localizedDescription: String {
        return super.localizedDescription
        
        // TODO: Make localizable description
    }
    
}

class ApiRequest<T: ApiResponseModel>: NSObject, ApiRequestProtocol {

    enum State {
        case initialized
        case waiting
        case sending
        case resending
        case responseSuccess
        case error
        case canceled
    }
    
    let host: String
    let path: String
    let uniqueType: String
    
    let type: ApiRequestType
    let method: HTTPMethod
    
    let parameters: Parameters
    let protobufRequest: SwiftProtobuf.Message?
    let multipartFormData: ((MultipartFormData) -> Void)?
    
    let successHandler: ((T) -> Void)
    let uploadProgressHandler: ((_ progress: Progress) -> Void)?
    let downloadProgressHandler: ((_ progress: Progress) -> Void)?
    let failureHandler: ((ApiRequestError) -> Void)
    
    var isEncrypted = false
    var isNeedsToBeGzipped = false
    
    var maxAttempts = 2
    var attemptWaitSeconds: Double = 1
    
    var urlString: String {
        return "\(ApiHostManager.baseUrl)\(self.path)"
    }
    
    private(set) var state = State.initialized
    private(set) var attempt = 1
    
    private(set) var requestHeaders = [String: String]()
    
    fileprivate var requestDataTask: DataRequest?
    
    init(protobufToHost host: String, path: String, uniqueType: String, protobufRequest: SwiftProtobuf.Message, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void), uploadProgressHandler: ((_ progress: Progress) -> Void)? = nil, downloadProgressHandler: ((_ progress: Progress) -> Void)? = nil) {
        
        self.host = host
        self.path = path
        self.uniqueType = uniqueType
        
        self.type = .protobuf
        self.method = .post
        
        self.parameters = [String: Any]()
        self.protobufRequest = protobufRequest
        self.multipartFormData = nil
        
        self.successHandler = successHandler
        self.uploadProgressHandler = uploadProgressHandler
        self.downloadProgressHandler = downloadProgressHandler
        self.failureHandler = failureHandler
    }
    
    init(host: String, path: String, uniqueType: String, params: Parameters, method: HTTPMethod, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void), uploadProgressHandler: ((_ progress: Progress) -> Void)? = nil, downloadProgressHandler: ((_ progress: Progress) -> Void)? = nil) {
        
        self.host = host
        self.path = path
        self.uniqueType = uniqueType
        
        self.type = .protobuf
        self.method = method
        
        self.parameters = params
        self.protobufRequest = nil
        self.multipartFormData = nil
        
        self.successHandler = successHandler
        self.uploadProgressHandler = uploadProgressHandler
        self.downloadProgressHandler = downloadProgressHandler
        self.failureHandler = failureHandler
    }
    
    init(multipartToHost host: String, path: String, uniqueType: String, multipartFormData: @escaping (MultipartFormData) -> Void, successHandler: @escaping ((T) -> Void), failureHandler: @escaping ((ApiRequestError) -> Void), uploadProgressHandler: ((_ progress: Progress) -> Void)? = nil, downloadProgressHandler: ((_ progress: Progress) -> Void)? = nil) {
        
        self.host = host
        self.path = path
        self.uniqueType = uniqueType
        
        self.type = .multipart
        self.method = .post
        
        self.parameters = [:]
        self.protobufRequest = nil
        self.multipartFormData = multipartFormData
        
        self.successHandler = successHandler
        self.uploadProgressHandler = uploadProgressHandler
        self.downloadProgressHandler = downloadProgressHandler
        self.failureHandler = failureHandler
    }
    
    private var attemptsDebugString: String {
        return "\(self.uniqueType)|" + (self.maxAttempts == 0 ? "*" : "\(self.attempt)|\(self.maxAttempts)")
    }
    
    public func start() {
        if !Queue.parse.isCurrentQueue {
            Queue.parse.run {
                self.start()
            }
            return
        }
        
        Queue.getterSetter.sync {
            if self.state != .resending {
                self.state = .sending
            }
        }
        
        let copyParams = self.parameters
        
        DDLogInfo("[API#\(self.attemptsDebugString)] prepare request: \(self.urlString) \(copyParams)")
        
        if self.requestHeaders.count == 0 {
            self.requestHeaders["Accept-Language"] = LocalizationManager.shared.language
            self.requestHeaders["x-rtfm-deviceid"] = UIDevice.current.uniqueDeviceIdentifier
            self.requestHeaders["x-rtfm-ios"] = UIDevice.current.systemVersion
            self.requestHeaders["x-rtfm-model"] = UIDevice.current.modelName
            if AuthManager.shared.userToken != "" {
                self.requestHeaders["x-rtfm-usertoken"] = AuthManager.shared.userToken
            }
        }
        var requestDataTask: DataRequest!
        do {
            requestDataTask = try ApiRequestEncoding.encode(request: self)
        } catch let error {
            Queue.getterSetter.sync {
                self.state = .error
            }
            
            Queue.main.run {
                self.failureHandler(ApiRequestError(code: .requestError, underlying: error, userInfo: [
                    ApiRequestError.Property.host.rawValue: self.host,
                    ApiRequestError.Property.method.rawValue: self.path
                    ]))
            }
            return
        }
        
        if let progressHandler = self.downloadProgressHandler {
            requestDataTask.downloadProgress(queue: DispatchQueue.main, closure: progressHandler)
        }
        
        if let progressHandler = self.uploadProgressHandler {
            if let dataTask = requestDataTask as? UploadRequest {
                dataTask.uploadProgress(queue: DispatchQueue.main, closure: progressHandler)
            }
        }
        
        requestDataTask.response { [weak self] (response) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.actionParseRequestResponse(response: response)
        }
        
        Queue.getterSetter.sync {
            self.requestDataTask = requestDataTask
            
            if InternetConnectionManager.shared.isReachable {
                self.state = .sending
                requestDataTask.resume()
                
                DDLogInfo("[API#\(self.attemptsDebugString)] send request: [\(requestDataTask.request?.httpMethod ?? "")] \(self.urlString)")
            } else {
                self.state = .waiting
                DDLogInfo("[API#\(self.attemptsDebugString)] wait for internet request: \(self.urlString)")
            }
            self.addToQueue()
        }
    }
    
    public func cancel() {
        Queue.getterSetter.sync {
            self.state = .canceled
            self.requestDataTask?.cancel()
            self.removeFromQueue()
        }
    }
    
    public func resumeAfterInternetConnection() {
        Queue.getterSetter.sync {
            if self.state != .waiting {
                return
            }
            
            guard let requestDataTask = self.requestDataTask else {
                return
            }
            
            requestDataTask.resume()
            self.state = .sending
        }
    }
    
    //MARK: - Private methods
    
    fileprivate func actionParseRequestResponse(response: DefaultDataResponse) {
        if !Queue.parse.isCurrentQueue {
            Queue.parse.run {
                self.actionParseRequestResponse(response: response)
            }
            return
        }
        
        guard let httpResponse = response.response else {
            DDLogInfo("[API#\(self.attemptsDebugString)] error get response for request: \(self.urlString)")
            
            Queue.getterSetter.sync {
                self.state = .error
                self.removeFromQueue()
            }
            Queue.main.run {
                if self.attempt >= self.maxAttempts && self.maxAttempts != 0 {
                    self.failureHandler(ApiRequestError(code: .responseNotFoundError, underlying: nil, userInfo: [
                        ApiRequestError.Property.host.rawValue: self.host,
                        ApiRequestError.Property.method.rawValue: self.path
                        ]))
                } else {
                    delay(self.attemptWaitSeconds, closure: {
                        self.attempt += 1
                        self.state = .resending
                        self.start()
                    })
                }
            }
            return
        }
        
        
        let statusCode = httpResponse.statusCode
        var contentType = httpResponse.allHeaderFields["Content-Type"] as? String ?? ""
        
        DDLogInfo("[API#\(self.attemptsDebugString)] get response for request: \(self.urlString) Content-Type: \(contentType) HTTP-Code: \(statusCode)")
        
        var responseData = response.data
        if let data = response.data {
            do {
                let response = try ApiRequestDecoding.decode(request: ApiRequestDecoding.Response(contentType: contentType, contentData: data), encryptedSecret: Data())
                contentType = response.contentType
                responseData = response.contentData
            } catch let error {
                Queue.getterSetter.sync {
                    self.state = .error
                    self.removeFromQueue()
                }
                Queue.main.run {
                    self.failureHandler(ApiRequestError(code: .responseDecryptError, underlying: error, userInfo: [
                        ApiRequestError.Property.host.rawValue: self.host,
                        ApiRequestError.Property.method.rawValue: self.path,
                        ApiRequestError.Property.httpCode.rawValue: statusCode
                        ]))
                }
                return
            }
        }
        
        if let nsError = response.error as NSError? {
            self.actionParseErrorResponse(response: httpResponse, responseObject: responseData, error: nsError)
        } else if let responseData = responseData, statusCode == 200 || statusCode == 201 || statusCode == 202 {
            self.actionParseSuccessResponse(response: httpResponse, contentType: contentType, data: responseData)
        } else {
            self.actionParseErrorResponse(response: httpResponse, responseObject: responseData, error: ApiRequestError(code: .responseStatusCodeError))
        }
    }
    
    fileprivate func actionParseSuccessResponse(response: HTTPURLResponse, contentType: String, data: Data) {
        Queue.getterSetter.sync {
            self.removeFromQueue()
        }
        
        var allHeaders = response.allHeaderFields
        allHeaders["Content-Type"] = contentType
        
        var responseModel: T!
        do {
            responseModel = try T.init(data: data, headers: allHeaders)
        } catch let error {
            Queue.getterSetter.sync {
                self.state = .error
            }
            
            Queue.main.run {
                DDLogInfo("[API#\(self.attemptsDebugString)] error parse response for request: \(self.urlString) error: \(error)")
                
                self.failureHandler(ApiRequestError(code: .responseParseError, underlying: error, userInfo: [
                    ApiRequestError.Property.host.rawValue: self.host,
                    ApiRequestError.Property.method.rawValue: self.path,
                    ApiRequestError.Property.httpCode.rawValue: response.statusCode
                    ]))
            }
            return
        }
        
        Queue.getterSetter.sync {
            self.state = .responseSuccess
        }
        
        Queue.main.run {
            DDLogInfo("[API#\(self.attemptsDebugString)] success response for request: \(self.urlString), bytes: \(response)")
            self.successHandler(responseModel)
        }
    }
    
    fileprivate func actionParseErrorResponse(response: HTTPURLResponse, responseObject: Any?, error: NSError) {
        self.removeFromQueue()
        
        let httpStatusCode = response.statusCode
        let errorCode = (response.allHeaderFields["x-errorcode"] as? String) ?? "unknown_error"
        
        if error.code == NSURLErrorCancelled {
            Queue.getterSetter.sync {
                self.state = .canceled
            }
            return
        }
        
        DDLogError("[API#\(self.attemptsDebugString)] error response for request: \(self.urlString) error: \(error) code: \(errorCode)")
        
        if (httpStatusCode >= 500 && httpStatusCode <= 600) {
            if let cookies = HTTPCookieStorage.shared.cookies(for: ApiHostManager.baseUrl) {
                for cookie in cookies {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
        
        if (httpStatusCode >= 400 && httpStatusCode <= 499) ||
            (self.attempt >= self.maxAttempts && self.maxAttempts != 0) {
            self.state = .error
            Queue.main.run {
                
                self.state = .error
                
                if error.domain == NSURLErrorDomain {
                    self.failureHandler(ApiRequestError(code: .connectionError, underlying: error, userInfo: [
                        ApiRequestError.Property.host.rawValue: self.host,
                        ApiRequestError.Property.method.rawValue: self.path,
                        ApiRequestError.Property.errorCode.rawValue: errorCode,
                        ApiRequestError.Property.httpCode.rawValue: response.statusCode
                        ]))
                } else {
                    self.failureHandler(ApiRequestError(code: .serverError, underlying: error, userInfo: [
                        ApiRequestError.Property.host.rawValue: self.host,
                        ApiRequestError.Property.method.rawValue: self.path,
                        ApiRequestError.Property.errorCode.rawValue: errorCode,
                        ApiRequestError.Property.httpCode.rawValue: response.statusCode
                        ]))
                }
            }
            return
        }
        
        DDLogInfo("[API#\(self.attemptsDebugString)] retry for request: \(self.urlString)")
        
        delay(self.attemptWaitSeconds, closure: {
            self.attempt += 1
            self.state = .resending
            self.start()
        })
    }
    
    fileprivate func addToQueue() {
        ApiRequestsQueueManager.shared.add(request: self)
    }
    
    fileprivate func removeFromQueue() {
        ApiRequestsQueueManager.shared.remove(request: self)
    }
    
}

