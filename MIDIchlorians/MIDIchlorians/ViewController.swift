//
//  ViewController.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SwiftyDropbox

// The ViewController is the main (and only) for the entire app.
// Management and hooking up all child view controllers are done in this class.
// The responsibilities of this class includes
// - setting up dimensions (might be replaced by autoconstraint / snapkit)
// - setting up delegates for side pane and grid
// - initializing default styles for some views
class ViewController: UIViewController {
    internal var topBarController: TopBarController!
    internal var sessionNavigationController: UINavigationController!
    internal var sidePaneController: SidePaneController!
    internal var gridController: GridController!
    internal var currentSession: Session!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopNav()
        setUpGrid()
        setUpSidePane()
        setUpStyles()
        setUpAnimation()
    }

    //FOR TESTING 
    override func viewDidAppear(_ animated: Bool) {
        loadDropBoxWebView()
    }

    // Sets up the top navigation.
    // The top navigation has controls to show the session table, so we set that up here as well.
    private func setUpTopNav() {
        let sessionTableViewController = SessionTableViewController(style: .plain)
        sessionNavigationController = UINavigationController(rootViewController: sessionTableViewController)
        // present the session table as a popover
        sessionNavigationController.modalPresentationStyle = .popover

        let navFrame = CGRect(origin: CGPoint.zero,
                              size: CGSize(width: view.frame.width, height: Config.TopNavHeight))
        topBarController = TopBarController(frame: navFrame)

        topBarController.modeSwitchDelegate = self
        topBarController.sessionSelectorDelegate = self

        view.addSubview(topBarController.view)
    }

    // Sets up the main grid for play/edit
    private func setUpGrid() {
        let frame = view.frame
        let gridFrame = CGRect(x: frame.minX + Config.AppLeftPadding,
                           y: frame.height * Config.MainViewHeightToGridMinYRatio,
                           width: frame.width - Config.AppLeftPadding - Config.AppRightPadding,
                           height: frame.height * Config.MainViewHeightToGridHeightRatio)
        currentSession = Session(bpm: Config.defaultBPM)
        gridController = GridController(frame: gridFrame, session: currentSession)

        view.addSubview(gridController.view)
    }

    // Sets up the side pane with controls for samples and animations
    private func setUpSidePane() {
        sidePaneController = SidePaneController()
        sidePaneController.sampleTableDelegate = gridController
        sidePaneController.animationTableDelegate = gridController

        let frame = view.frame
        sidePaneController.view.frame =
            CGRect(x: frame.width * Config.MainViewWidthToSideMinXRatio,
                   y: frame.height * Config.MainViewHeightToSideMinYRatio,
                   width: frame.width * Config.MainViewWidthToSideWidthRatio,
                   height: frame.height * Config.MainViewHeightToSideHeightRatio)
    }

    // Sets up application wide styles
    private func setUpStyles() {
        view.backgroundColor = Config.BackgroundColor

        // proxy to make all table views have the same background color
        UITableView.appearance().backgroundColor = Config.BackgroundColor
        UITableViewCell.appearance().backgroundColor = Config.BackgroundColor
    }

    // Sets up the animation engine
    private func setUpAnimation() {
        AnimationEngine.set(animationGrid: gridController.gridView)
        AnimationEngine.start()
    }

    func loadDropBoxWebView() {
        print("AAAA")
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                      UIApplication.shared.openURL(url)
        }, browserAuth: false)
    }

    func importFromDropbox() {
        var audioFileNames = [String]()
        guard let client = DropboxClientsManager.authorizedClient else {
            return
        }
        _ = client.files.listFolder(path: "").response { response, error in
            guard let result = response else {
                return
            }
            for entry in result.entries {
                if entry.name.hasSuffix(".wav") {
                    audioFileNames.append(entry.name)
                }
            }
        }
    }

    func saveToDropbox() {

    }

}

// Called when the mode is switch. Passes on the event to the grid and side pane
extension ViewController: ModeSwitchDelegate {
    func enterEdit() {
        gridController.enterEdit()
        view.addSubview(sidePaneController.view)
    }

    func enterPlay() {
        // error handling
        gridController.enterPlay()
        sidePaneController.view.removeFromSuperview()
    }
}

// Called when session selector is tapped, shows the sessions as a popover
extension ViewController: SessionSelectorDelegate {
    func sessionSelector(sender: UIBarButtonItem) {
        present(sessionNavigationController, animated: false, completion: nil)

        // configure styles and anchor of popover presentation controller
        let popoverPresentationController = sessionNavigationController.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = [.up]
        popoverPresentationController?.barButtonItem = sender
        popoverPresentationController?.backgroundColor = Config.BackgroundColor
    }
}
