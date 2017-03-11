//
//  ViewController.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

extension ViewController: EditButtonDelegate {
    func editStart() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditStart)
        sidePaneViewController.view.frame = CGRect(
            x: 774, y: self.gridCollection.frame.minY, width: 250, height: self.gridCollection.frame.height)
        self.view.addSubview(sidePaneViewController.view)
    }

    func editEnd() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditEnd)
        sidePaneViewController.view.removeFromSuperview()
    }

    private func resizePads(by factor: CGFloat) {
        // TODO extend UIView to add methods for updating size?
        // and to animate the changes refer to
        // http://stackoverflow.com/questions/13780153/uicollectionview-animate-cell-size-change-on-selection
        self.gridCollection.frame = CGRect(
            origin: self.gridCollection.frame.origin,
            size: self.gridCollection.frame.size.scale(by: factor))
        self.gridCollection.collectionViewLayout.invalidateLayout()
    }
}

class ViewController: UIViewController {
    @IBOutlet var gridCollection: GridCollectionView!
    var editButtonController: EditButton!
    var trackTableViewController: TrackTableViewController!
    // for testing purposes
    var animationTableViewController: AnimationTableViewController!
    var trackNavigationController: UINavigationController!
    var animationNavigationController: UINavigationController!

    var sidePaneViewController: SidePaneTabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        fixGridDimensions()

        editButtonController = EditButton(superview: self.view, delegate: self)

        gridCollection.dataSource = gridCollection
        gridCollection.delegate = gridCollection
        AnimationEngine.set(animationCollectionView: gridCollection)
        AnimationEngine.start()
        gridCollection.startListenAudio()

        trackTableViewController = TrackTableViewController(style: .plain)
        trackNavigationController = SideNavigationViewController(rootViewController: trackTableViewController)
        animationTableViewController = AnimationTableViewController(style: .plain)
        animationNavigationController = SideNavigationViewController(rootViewController: animationTableViewController)
        sidePaneViewController = SidePaneTabBarController()
        sidePaneViewController.viewControllers = [trackNavigationController, animationNavigationController]
        sidePaneViewController.selectedViewController = trackNavigationController

        // proxy to make all table views have the same background color
        UITableView.appearance().backgroundColor = Config.BackgroundColor
        UITableViewCell.appearance().backgroundColor = Config.BackgroundColor
    }

    func fixGridDimensions() {
        // fix the width of the button collection view
        let totalWidth = self.view.frame.width - 20 - 20 // padding left and right
        // left with 9 columns of buttons with 8 insets in between
        // so to get width for the pads we add 1 inset and times 8/9
        let padWidth = (totalWidth + Config.ItemInsets.right) *
            (CGFloat(Config.numberOfColumns) / CGFloat(Config.numberOfColumns + 1))
        let padHeight = padWidth / CGFloat(Config.numberOfColumns) * CGFloat(Config.numberOfRows)
        gridCollection.frame = CGRect(
            origin: gridCollection.frame.origin,
            size: CGSize(width: padWidth, height: padHeight))
    }
}
