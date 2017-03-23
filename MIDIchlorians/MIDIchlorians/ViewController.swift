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
        sidePaneController.view.frame = CGRect(x: minX, y: minY, width: width, height: fullHeight)
        self.view.addSubview(sidePaneController.view)
        self.mode = .Editing
    }

    func enterPlay() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditEnd)
        sidePaneController.view.removeFromSuperview()
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

extension ViewController: SessionSelectorDelegate {
    func sessionSelector(sender: UIBarButtonItem) {
        self.present(sessionNavigationController, animated: false, completion: nil)

        // configure styles and anchor of popover presentation controller
        let popoverPresentationController = sessionNavigationController.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = [.up]
        popoverPresentationController?.barButtonItem = sender
        popoverPresentationController?.backgroundColor = Config.BackgroundColor
    }
}

class ViewController: UIViewController {
    @IBOutlet var gridCollection: GridCollectionView!
    var mode: Mode = .Playing {
        didSet {
            self.gridCollection.mode = mode
        }
    }
    private var topBarController: TopBarController!
    internal var sessionNavigationController: UINavigationController!
    internal var sidePaneController: SidePaneController!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Config.BackgroundColor

        fixGridDimensions()

        gridCollection.dataSource = gridCollection
        gridCollection.delegate = gridCollection
        // tentatively for prototyping purpose
        gridCollection.currentSession = Session(bpm: Config.defaultBPM)
        gridCollection.startListenAudio()
        gridCollection.backgroundColor = Config.BackgroundColor

        AnimationEngine.set(animationCollectionView: gridCollection)
        AnimationEngine.start()

        setUpTopNav()
        setUpSidePane()
        setUpStyles()
    }

    // Sets up the top navigation.
    // The top navigation has controls to show the session table, so we set that up here as well.
    private func setUpTopNav() {
        let sessionTableViewController = SessionTableViewController(style: .plain)
        sessionNavigationController = UINavigationController(rootViewController: sessionTableViewController)
        // present the session table as a popover
        sessionNavigationController.modalPresentationStyle = .popover

        topBarController = TopBarController()

        topBarController.configureWidth(width: self.view.frame.width)
        topBarController.modeSwitchDelegate = self
        topBarController.sessionSelectorDelegate = self

        self.view.addSubview(topBarController.view)
    }

    private func setUpSidePane() {
        sidePaneController = SidePaneController()
    }

    private func setUpStyles() {
        // proxy to make all table views have the same background color
        UITableView.appearance().backgroundColor = Config.BackgroundColor
        UITableViewCell.appearance().backgroundColor = Config.BackgroundColor
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
