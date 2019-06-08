//
//  BaseError.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

protocol BaseErrorCode: RawRepresentable where RawValue == Int {}
protocol BaseErrorProtocol {
    var underlyingError: NSError? { get }
    var shortCodesChain: String { get }
    var domainShortname: String { get }
    var crashlyticsUserInfo: [String: Any] { get }
}

class BaseError<ErrorCode: BaseErrorCode>: NSError, BaseErrorProtocol {
    
    required init(code: ErrorCode, underlying: Error? = nil, systemMsg: String? = nil) {
        var userInfo = [String : Any]()
        if let underlying = underlying {
            userInfo[NSUnderlyingErrorKey] = underlying
        }
        if let systemMsg = systemMsg {
            userInfo[NSLocalizedFailureReasonErrorKey] = systemMsg
        }
        super.init(domain: String(describing: type(of: self)), code: code.rawValue, userInfo: userInfo)
    }
    
    required init(code: ErrorCode, underlying: Error? = nil, userInfo: [String: Any]) {
        var errorUserInfo = userInfo
        if let underlying = underlying {
            errorUserInfo[NSUnderlyingErrorKey] = underlying
        }
        super.init(domain: String(describing: type(of: self)), code: code.rawValue, userInfo: errorUserInfo)
    }
    
    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var underlyingError: NSError? {
        return self.userInfo[NSUnderlyingErrorKey] as? NSError
    }
    
    var shortCodesChain: String {
        var code = "\(self.domainShortname)\(self.code)"
        if let errorProtocol = self.underlyingError as? BaseErrorProtocol {
            code += "_\(errorProtocol.shortCodesChain)"
        } else if let error = self.underlyingError {
            code += "_\(error.domain)\(error.code)"
        }
        return code
    }
    
    var crashlyticsUserInfo: [String: Any] {
        var userInfo = [String: Any]()
        if let errorProtocol = self.underlyingError as? BaseErrorProtocol {
            for (key, value) in errorProtocol.crashlyticsUserInfo {
                userInfo[key] = value
            }
        } else if let error = self.underlyingError {
            for (key, value) in error.userInfo {
                userInfo["DFER_\(key)"] = value
            }
            userInfo["DFER_localized_description"] = error.localizedDescription
            userInfo["DFER_debug_description"] = error.debugDescription
        }
        
        for (key, value) in self.userInfo {
            if key == NSUnderlyingErrorKey {
                continue
            }
            userInfo["\(self.domainShortname)_\(key)"] = value
        }
        userInfo["\(self.domainShortname)_localized_description"] = self.localizedDescription
        userInfo["\(self.domainShortname)_debug_description"] = self.debugDescription
        return userInfo
    }
    
    open override var domain: String {
        return String(describing: type(of: self))
    }
    
    var errorCode: ErrorCode {
        return ErrorCode(rawValue: self.code)!
    }
    var errorCodeName: String {
        return String(describing: self.errorCode)
    }
    
    var domainShortname: String {
        return "BE"
    }
    
}
