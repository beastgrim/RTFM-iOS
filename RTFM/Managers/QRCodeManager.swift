//
//  QRCodeManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation
import EFQRCode

class QRCodeManager {
    
    class func generateQRCode(string: String) -> UIImage {
        let image = EFQRCode.generate(content: string)!
        
        return UIImage(cgImage: image)
    }
}
