//
//  AuthManager.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

class AuthManager {
    static let shared: AuthManager = .init()
    
    private(set) var userToken: String = ""
}
