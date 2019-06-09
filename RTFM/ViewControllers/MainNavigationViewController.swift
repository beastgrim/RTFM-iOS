//
//  MainNavigationViewController.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.prefersLargeTitles = true
        
        if let viewController = self.viewControllers.last {
            self.navigationBar.setBackgroundImage(viewController.navigationBarBackgroundImage, for: .default)
            self.navigationBar.largeTitleTextAttributes = viewController.largeTitleAttributes
            self.navigationBar.barTintColor = viewController.navigationBarTintColor
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        self.navigationBar.setBackgroundImage(viewController.navigationBarBackgroundImage, for: .default)
        self.navigationBar.largeTitleTextAttributes = viewController.largeTitleAttributes
        self.navigationBar.barTintColor = viewController.navigationBarTintColor
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let result = super.popViewController(animated: animated)
        if let viewController = self.viewControllers.last {
            self.navigationBar.setBackgroundImage(viewController.navigationBarBackgroundImage, for: .default)
            self.navigationBar.largeTitleTextAttributes = viewController.largeTitleAttributes
            self.navigationBar.barTintColor = viewController.navigationBarTintColor
        }
        return result
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let result = super.popToViewController(viewController, animated: animated)
        return result
    }
}
