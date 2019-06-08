//
//  ApiRequestDecoding.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

class ApiRequestDecoding {
    struct Response {
        let contentType: String
        let contentData: Data
    }
    
    class func decode(request: Response, encryptedSecret: Data) throws -> Response {
        
        let contentType = request.contentType
        let contentData = request.contentData
        
        return Response(contentType: contentType, contentData: contentData)
    }
}
