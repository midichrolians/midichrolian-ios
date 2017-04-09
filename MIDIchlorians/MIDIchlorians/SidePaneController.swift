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

    internal let animationTableViewController = AnimationTableViewController(style: .plain)
    internal var animationNavigationController: UINavigationController

    internal let groups = GroupTableViewController(style: .plain)
    let groupNav: UINavigationController

    private let sidePaneViewController = SidePaneTabBarController()

    var sampleTableDelegate: SampleTableDelegate? {
        didSet {
            self.groups.delegate = sampleTableDelegate
        }
    }
    var animationTableDelegate: AnimationTableDelegate? {
        didSet {
            self.animationTableViewController.delegate = animationTableDelegate
        }
    }

    override init() {
        animationNavigationController = SideNavigationViewController(rootViewController: animationTableViewController)

        groupNav = SideNavigationViewController(rootViewController: groups)

        super.init()

        sidePaneViewController.viewControllers = [
            groupNav,
            animationNavigationController
        ]
        sidePaneViewController.selectedIndex = 0
        sidePaneViewController.delegate = self
    }

}

extension SidePaneController: PadDelegate {
    // Get index of animation assigned to selected pad in animation list
    private func indexOfAnimation(assignedTo pad: Pad) -> Int? {
        return pad
            .getAnimation()?
            .name
            .flatMap { animation in animationTableViewController.animationTypeNames.index(of: animation) }
    }

    // Deselect currently selected row in animation table view
    private func deselectAllAnimations() {
        animationTableViewController.tableView.indexPathForSelectedRow
            .map { indexPath in
                animationTableViewController.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // When a pad is selected in edit mode, we want to select 2 things:
    // 1. group
    // 2. sample in the list of samples in group
    // If the sample cannot be found, deselect everything
    private func highlightSample(assignedTo pad: Pad) {
        // unhighlight if pad has no name
        guard let name = pad.getAudioFile() else {
            if let tableVC = groupNav.topViewController as? UITableViewController {
                tableVC.tableView.deselectAll()
            }
            return
        }
        groups.selectedSampleName = name

        if let tv = groupNav.topViewController as? GroupTableViewController {
            tv.selectedSampleName = name
            // need to get audio group from pad
        }
        if let tvc = groupNav.topViewController as? SampleTableViewController {
            tvc.selectedSampleName = name
            tvc.highlight(sample: name)
        }
    }

    // When a pad is selected in edit mode, we want to highlight/select the row in the table view
    // that is the animation assigned to the pad
    // If the pad has no animation assigned, deselect everything.
    private func highlightAnimation(assignedTo: Pad) {
        guard let animationIndex = indexOfAnimation(assignedTo: assignedTo) else {
            deselectAllAnimations()
            return
        }
        animationTableViewController.tableView.selectRow(at: IndexPath(row: animationIndex, section: 0),
                                                         animated: true,
                                                         scrollPosition: .middle)
    }

    func pad(selected: Pad) {
        highlightSample(assignedTo: selected)
        highlightAnimation(assignedTo: selected)
    }
}

extension SidePaneController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == groupNav {
            delegate?.sidePaneSelectSample()
        } else if viewController == animationNavigationController {
            delegate?.sidePaneSelectAnimation()
        }
    }

}

extension SidePaneController: AnimationDesignerDelegate {
    func saveAnimation(name: String) {
        let names = animationTableViewController.animationTypeNames
        let insertIndex = names.index(where: { $0 > name }) ?? names.endIndex
        animationTableViewController.animationTypeNames.insert(name, at: insertIndex)
        animationTableViewController.tableView.insertRows(
            at: [IndexPath(row: insertIndex, section: 0)], with: .fade)
    }
}
