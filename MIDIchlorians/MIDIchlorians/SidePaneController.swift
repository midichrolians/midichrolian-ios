//
//  SidePaneController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 23/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

class SidePaneController {
    let sidePaneViewController = SidePaneTabBarController()
    private let sampleTableViewController = SampleTableViewController(style: .plain)
    private let animationTableViewController = AnimationTableViewController(style: .plain)
    private var sampleNavigationController: UINavigationController
    private var animationNavigationController: UINavigationController

    var sampleTableDelegate: SampleTableDelegate? {
        didSet {
            self.sampleTableViewController.delegate = sampleTableDelegate
        }
    }
    var animationTableDelegate: AnimationTableDelegate? {
        didSet {
            self.animationTableViewController.delegate = animationTableDelegate
        }
    }

    init() {
        sampleNavigationController = SideNavigationViewController(rootViewController: sampleTableViewController)

        animationNavigationController = SideNavigationViewController(rootViewController: animationTableViewController)

        sidePaneViewController.viewControllers = [
            sampleNavigationController,
            animationNavigationController
        ]
        sidePaneViewController.selectedIndex = 0
    }

}
