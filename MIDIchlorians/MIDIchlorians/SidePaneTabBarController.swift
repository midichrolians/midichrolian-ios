//
//  SidePaneTabBarController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Controller for the side panel when in editing mode.
class SidePaneTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barStyle = .black
        self.tabBar.backgroundColor = Config.BackgroundColor
        self.tabBar.tintColor = Config.FontPrimaryColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
