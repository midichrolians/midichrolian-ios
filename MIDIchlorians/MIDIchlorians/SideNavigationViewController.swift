//
//  SideNavigationViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Parent class for all navigation view controllers to be added to the side pane.
// This sets common styles for these view controllers, such as the background colour and tint.
class SideNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barStyle = .default
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = Config.SecondaryBackgroundColor
        self.navigationBar.tintColor = Config.FontSecondaryColor
        self.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: Config.FontSecondaryColor
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
