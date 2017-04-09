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
    private func indexOfSample(assignedTo pad: Pad) -> Int? {
        return pad
            .getAudioFile()
            .flatMap { sample in sampleTableViewController.sampleList.index(of: sample) }
    }

    // Get index of animation assigned to selected pad in animation list
    private func indexOfAnimation(assignedTo pad: Pad) -> Int? {
        return pad
            .getAnimation()?
            .name
            .flatMap { animation in animationTableViewController.animationTypeNames.index(of: animation) }
    }

    // Deselect currently selected row in sample table view
    private func deselectAllSamples() {
        sampleTableViewController.tableView.indexPathForSelectedRow
            .map { indexPath in
                sampleTableViewController.tableView.deselectRow(at: indexPath, animated: true)
            }
    }

    // Deselect currently selected row in animation table view
    private func deselectAllAnimations() {
        animationTableViewController.tableView.indexPathForSelectedRow
            .map { indexPath in
                animationTableViewController.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // When a pad is selected in edit mode, we want to highlight/select the row in the table view
    // that is the sample assigned to the pad
    // If the pad has no sample assigned, deselect everything.
    private func highlightSample(assignedTo: Pad) {
        guard let sampleIndex = indexOfSample(assignedTo: assignedTo) else {
            deselectAllSamples()
            return
        }
        sampleTableViewController.tableView.selectRow(at: IndexPath(row: sampleIndex, section: 0),
                                                      animated: true,
                                                      scrollPosition: .middle)
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
        if viewController == sampleNavigationController {
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
