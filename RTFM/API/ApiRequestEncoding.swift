//
//  ApiRequestEncoding.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import Alamofire

class ApiRequestEncodingError: BaseError<ApiRequestEncodingError.Code> {
    enum Code: Int, BaseErrorCode {
        case requestURL
        case jsonEncoding
        case urlEncoding
        case protobufEncoding
        case multipartEncoding
        case encryptedKey
        case encryptedEnvelope
        case encryptedPayload
    }
    
    override var domainShortname: String {
        return "FE"
    }
}

class ApiRequestEncoding  {
    
    class func encode(request: ApiRequestProtocol) throws -> DataRequest {
        guard let requestURL = URL(string: request.urlString) else {
            throw ApiRequestEncodingError(code: .requestURL)
        }

        var urlRequest = try URLRequest(url: requestURL, method: request.method, headers: request.requestHeaders)
        
        var requestData: Data?
        
        switch request.type {
        case .json:
            
            if request.method == .post {
                do {
                    urlRequest = try JSONEncoding.default.encode(urlRequest, with: request.parameters)
                } catch let error {
                    throw ApiRequestEncodingError(code: .jsonEncoding, underlying: error, systemMsg: nil)
                }
                
                requestData = urlRequest.httpBody
                if requestData == nil {
                    if let inputStream = urlRequest.httpBodyStream {
                        requestData = Data(reading: inputStream)
                    }
                }
                
            } else {
                do {
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: request.parameters)
                } catch let error {
                    throw ApiRequestEncodingError(code: .urlEncoding, underlying: error, systemMsg: nil)
                }
            }
            
        case .multipart:
            
            let formData = MultipartFormData()
            request.multipartFormData?(formData)
            urlRequest.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
            
            do {
                requestData = try formData.encode()
            } catch let error {
                throw ApiRequestEncodingError(code: .multipartEncoding, underlying: error, systemMsg: nil)
            }
            
        case .protobuf:
            do {
                let serializedData = try request.protobufRequest!.serializedData()
                requestData = serializedData
                
                urlRequest.setValue("application/protobuf", forHTTPHeaderField: "Content-Type")
            } catch let error {
                throw ApiRequestEncodingError(code: .protobufEncoding, underlying: error, systemMsg: nil)
            }
            
        }
        
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        for (key, value) in request.requestHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        switch request.type {
        case .json:
            if request.method == .post {
                urlRequest.httpBodyStream = nil
                urlRequest.httpBody = requestData
            }
            return ApiHostManager.operationSession.request(urlRequest)
        case .multipart:
            return ApiHostManager.operationSession.upload(requestData ?? Data(), with: urlRequest)
        case .protobuf:
            return ApiHostManager.operationSession.upload(requestData ?? Data(), with: urlRequest)
        }
    }
}
