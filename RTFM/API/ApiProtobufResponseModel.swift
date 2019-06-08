//
//  ApiProtobufResponseModel.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import SwiftProtobuf

class ApiProtobufResponseModel<ProtobufObject: SwiftProtobuf.Message>: ApiResponseModel {
    
    let protobufObject: ProtobufObject
    
    init(protobufObject: ProtobufObject) {
        self.protobufObject = protobufObject
        super.init()
    }
    
    required init(data: Data, headers: [AnyHashable: Any]) throws {
        self.protobufObject = try ProtobufObject(serializedData: data)
        
        try super.init(data: data, headers: headers)
    }
    
}
