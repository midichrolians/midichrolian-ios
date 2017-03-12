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
        let fullHeight = self.gridCollection.frame.height

        resizePads(by: Config.PadAreaResizeFactorWhenEditStart)

        let minX = self.gridCollection.frame.maxX + Config.ItemInsets.right
        let width = self.view.frame.width - self.gridCollection.frame.width - 20
        sidePaneViewController.view.frame = CGRect(
            x: minX, y: self.gridCollection.frame.minY, width: width, height: fullHeight)
        self.view.addSubview(sidePaneViewController.view)
        self.mode = .Editing
    }

    func editEnd() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditEnd)
        sidePaneViewController.view.removeFromSuperview()
        self.mode = .Playing
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
    var mode: Mode = .Playing {
        didSet {
            self.gridCollection.mode = mode
        }
    }
    var editButtonController: EditButton!

    var trackTableViewController: TrackTableViewController!
    var trackNavigationController: UINavigationController!

    var animationTableViewController: AnimationTableViewController!
    var animationNavigationController: UINavigationController!

    var sessionTableViewController: SessionTableViewController!
    var sessionNavigationController: UINavigationController!

    var sidePaneViewController: SidePaneTabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Config.BackgroundColor

        fixGridDimensions()

        editButtonController = EditButton(superview: self.view, delegate: self)

        gridCollection.dataSource = gridCollection
        gridCollection.delegate = gridCollection
        AnimationEngine.set(animationCollectionView: gridCollection)
        AnimationEngine.start()
        gridCollection.startListenAudio()
        gridCollection.backgroundColor = Config.BackgroundColor

        setUpSidePane()

        // proxy to make all table views have the same background color
        UITableView.appearance().backgroundColor = Config.BackgroundColor
        UITableViewCell.appearance().backgroundColor = Config.BackgroundColor
    }

    // Sets up the side pane that comes into view when user enters editing mode.
    // The side pane is made up of
    // - a TabBarController which manages a list of
    //   - UINavigationControllers, each of which
    //     - wraps a TableViewController
    // these system view controllers are all subclassed to provide default styles
    func setUpSidePane() {
        trackTableViewController = TrackTableViewController(style: .plain)
        trackNavigationController = SideNavigationViewController(rootViewController: trackTableViewController)

        animationTableViewController = AnimationTableViewController(style: .plain)
        animationNavigationController = SideNavigationViewController(rootViewController: animationTableViewController)

        sessionTableViewController = SessionTableViewController(style: .plain)
        sessionNavigationController = SideNavigationViewController(rootViewController: sessionTableViewController)

        sidePaneViewController = SidePaneTabBarController()
        sidePaneViewController.viewControllers = [
            trackNavigationController,
            animationNavigationController,
            sessionNavigationController
        ]
        sidePaneViewController.selectedIndex = 0
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
