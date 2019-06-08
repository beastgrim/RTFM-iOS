//
//  UIDeviceExtensions.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var uniqueDeviceIdentifier: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    var modelName: String {
        return UIDevice.current.model
    }
}
