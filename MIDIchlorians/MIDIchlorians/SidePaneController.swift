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
class SidePaneController: NSObject {
    var view: UIView {
        return sidePaneViewController.view as UIView
    }
    weak var delegate: SidePaneDelegate?

    internal let sampleTableViewController = SampleTableViewController(style: .plain)
    internal let animationTableViewController = AnimationTableViewController(style: .plain)
    internal var sampleNavigationController: UINavigationController
    internal var animationNavigationController: UINavigationController

    private let sidePaneViewController = SidePaneTabBarController()

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

    override init() {
        sampleNavigationController = SideNavigationViewController(rootViewController: sampleTableViewController)
        animationNavigationController = SideNavigationViewController(rootViewController: animationTableViewController)

        super.init()

        sidePaneViewController.viewControllers = [
            sampleNavigationController,
            animationNavigationController
        ]
        sidePaneViewController.selectedIndex = 0
        sidePaneViewController.delegate = self
    }

}

extension SidePaneController: PadDelegate {
    // Get index of sample assigned to selected pad in sample list
    private func index(of selected: Pad) -> Int? {
        return selected
            .getAudioFile()
            .flatMap { sample in sampleTableViewController.sampleList.index(of: sample) }
    }

    // Deselect currently selected row in table view
    private func deselect() {
        sampleTableViewController.tableView.indexPathForSelectedRow
            .map { indexPath in
                sampleTableViewController.tableView.deselectRow(at: indexPath, animated: true)
            }
    }

    // When a pad is selected in edit mode, we want to highlight/select the row in the table view
    // that is the sample assigned to the pad
    // If the pad has no sample assigned, deselect everything.
    func pad(selected: Pad) {
        guard let index = index(of: selected) else {
            deselect()
            return
        }

        sampleTableViewController.tableView.selectRow(at: IndexPath(row: index, section: 0),
                                                      animated: true,
                                                      scrollPosition: .middle)
    }
}

extension SidePaneController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == sampleNavigationController {
            delegate?.sidePaneSelectSample()
        } else if viewController == animationNavigationController {
            delegate?.sidePaneSelectAnimation()
        }
    }

}
