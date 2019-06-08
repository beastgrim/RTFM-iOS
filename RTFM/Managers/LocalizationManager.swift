//
//  LocalizationManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

class LocalizationManager {
    static let shared: LocalizationManager = .init()
    let language: String = "en"
    
    private init() {
        
    }
}
