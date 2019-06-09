//
//  UIViewControllerExtensions.swift
//  RTFM
//
//  Created by Евгений Богомолов on 09/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

protocol UIViewControllerNavigationStyle {
    var largeTitleAttributes: [NSAttributedString.Key : Any]? { get }
    var navigationBarBackgroundImage: UIImage? { get }
    var navigationBarTintColor: UIColor? { get }
}

extension UIViewController: UIViewControllerNavigationStyle {
    @objc var largeTitleAttributes: [NSAttributedString.Key : Any]? {
        return [.foregroundColor: UIColor.black]
    }
    
    @objc var navigationBarBackgroundImage: UIImage? {
        return nil
    }
    
    @objc var navigationBarTintColor: UIColor? {
        return nil
    }
}
