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
        let gridCollection = self.gridController.view
        let fullHeight = gridCollection.frame.height

        gridController.enterEdit()
        // set the dimensions, replace with constraints soon

        let minX = gridCollection.frame.maxX + Config.ItemInsets.right
        let minY = gridCollection.frame.minY
        let width = self.view.frame.width - gridCollection.frame.width
            - Config.AppLeftPadding - Config.AppRightPadding
        sidePaneController.setDimension(frame:
            CGRect(x: minX, y: minY, width: width, height: fullHeight))
        self.view.addSubview(sidePaneController.view)
    }

    func enterPlay() {
        gridController.enterPlay()
        sidePaneController.view.removeFromSuperview()
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
    private var topBarController: TopBarController!
    internal var sessionNavigationController: UINavigationController!
    internal var sidePaneController: SidePaneController!
    internal var gridController: GridController!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Config.BackgroundColor

        self.gridController = GridController(gridCollectionView: self.gridCollection)

        self.gridController.setGridDimensions(superWidth: self.view.frame.width)

        AnimationEngine.set(animationCollectionView: self.gridController.view)
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

}
