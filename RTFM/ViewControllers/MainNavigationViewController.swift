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

        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationBar.barTintColor = .clear
        self.navigationBar.prefersLargeTitles = true
    }
}
