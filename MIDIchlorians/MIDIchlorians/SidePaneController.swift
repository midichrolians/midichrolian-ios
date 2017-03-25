//
//  SidePaneController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 23/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

// A side pane is used by the user to add/edit/browse samples and animations.
// It appears view when user enters editing mode.
// The side pane is made up of
// - a TabBarController which manages a list of
//   - UINavigationControllers, each of which
//     - wraps a TableViewController
// these system view controllers are all subclassed to provide default styles
class SidePaneController {
    var view: UIView {
        return sidePaneViewController.view as UIView
    }
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

    func setDimension(frame: CGRect) {
        self.view.frame = frame
    }

}
