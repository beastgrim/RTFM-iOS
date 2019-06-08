//
//  UIStoryboardExtensions.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    class func viewController<T>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let id = String(describing: T.self)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        return vc as! T
    }
}
