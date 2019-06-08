//
//  DataExtensions.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

extension Data {
    
    init(reading input: InputStream) {
        self.init()
        input.open()
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read == 0 {
                break
            }
            self.append(buffer, count: read)
        }
        buffer.deallocate()
        
        input.close()
    }
    
    func sha256() -> Data {
        assertionFailure("TODO")
        return self
//        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
//        self.withUnsafeBytes {
//            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
//        }
//        return Data(hash)
    }
    
}

