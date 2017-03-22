//
//  ViewController.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

extension ViewController: ModeSwitchDelegate {
    func enterEdit() {
        let fullHeight = self.gridCollection.frame.height

        resizePads(by: Config.PadAreaResizeFactorWhenEditStart)

        let minX = self.gridCollection.frame.maxX + Config.ItemInsets.right
        let minY = self.gridCollection.frame.minY
        let width = self.view.frame.width - self.gridCollection.frame.width
            - Config.AppLeftPadding - Config.AppRightPadding
        sidePaneViewController.view.frame = CGRect(x: minX, y: minY, width: width, height: fullHeight)
        self.view.addSubview(sidePaneViewController.view)
        self.mode = .Editing
    }

    func enterPlay() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditEnd)
        sidePaneViewController.view.removeFromSuperview()
        self.mode = .Playing
    }

    private func resizePads(by factor: CGFloat) {
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
    private var topNavigationBar: TopNavigationBar!

    private var sampleTableViewController: SampleTableViewController!
    private var sampleNavigationController: UINavigationController!

    private var animationTableViewController: AnimationTableViewController!
    private var animationNavigationController: UINavigationController!

    private var sessionTableViewController: SessionTableViewController!
    private var sessionNavigationController: UINavigationController!

    internal var sidePaneViewController: SidePaneTabBarController!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Config.BackgroundColor

        fixGridDimensions()

        gridCollection.dataSource = gridCollection
        gridCollection.delegate = gridCollection
        AnimationEngine.set(animationCollectionView: gridCollection)
        AnimationEngine.start()
        gridCollection.startListenAudio()
        gridCollection.backgroundColor = Config.BackgroundColor

        setUpTopNav()
        setUpSidePane()

        // proxy to make all table views have the same background color
        UITableView.appearance().backgroundColor = Config.BackgroundColor
        UITableViewCell.appearance().backgroundColor = Config.BackgroundColor
    }

    // Sets up the top navigation.
    // The top navigation has controls to show the session table, so we set that up here as well.
    private func setUpTopNav() {
        sessionTableViewController = SessionTableViewController(style: .plain)
        sessionNavigationController = UINavigationController(rootViewController: sessionTableViewController)
        topNavigationBar = TopNavigationBar(
            frame: CGRect(origin: CGPoint.zero,
                          size: CGSize(width: self.view.frame.width, height: Config.TopNavHeight)))
        self.view.addSubview(topNavigationBar)
        topNavigationBar.modeSwitchDelegate = self
        topNavigationBar.addTargetToSessionSelector(self, action: #selector(sessionSelect(sender:)))
    }

    // Sets up the side pane that comes into view when user enters editing mode.
    // The side pane is made up of
    // - a TabBarController which manages a list of
    //   - UINavigationControllers, each of which
    //     - wraps a TableViewController
    // these system view controllers are all subclassed to provide default styles
    private func setUpSidePane() {
        sampleTableViewController = SampleTableViewController(style: .plain)
        sampleNavigationController = SideNavigationViewController(rootViewController: sampleTableViewController)

        animationTableViewController = AnimationTableViewController(style: .plain)
        animationNavigationController = SideNavigationViewController(rootViewController: animationTableViewController)

        sidePaneViewController = SidePaneTabBarController()
        sidePaneViewController.viewControllers = [
            sampleNavigationController,
            animationNavigationController
        ]
        sidePaneViewController.selectedIndex = 0
    }

    // Called when the session button on the top nav is pressed
    func sessionSelect(sender: UIBarButtonItem) {
        // present the session table as a popover
        sessionNavigationController.modalPresentationStyle = .popover
        self.present(sessionNavigationController, animated: false, completion: nil)

        // configure styles and anchor of popover
        let popoverPresentationController = sessionNavigationController.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = [.up]
        popoverPresentationController?.barButtonItem = sender
        popoverPresentationController?.backgroundColor = Config.BackgroundColor
    }

    private func fixGridDimensions() {
        // fix the width of the button collection view
        let totalWidth = self.view.frame.width - Config.AppLeftPadding - Config.AppRightPadding
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
