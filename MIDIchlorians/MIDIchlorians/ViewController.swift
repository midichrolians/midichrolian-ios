//
//  ViewController.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import RealmSwift
// The ViewController is the main (and only) for the entire app.
// Management and hooking up all child view controllers are done in this class.
// The responsibilities of this class includes
// - setting up dimensions (might be replaced by autoconstraint / snapkit)
// - setting up delegates for side pane and grid
// - initializing default styles for some views
class ViewController: UIViewController {
    internal var topBarController: TopBarController!
    internal var sessionNavigationController: UINavigationController!
    internal var sessionTableViewController: SessionTableViewController!
    internal var sidePaneController: SidePaneController!
    internal var animationDesignController: AnimationDesignerController!
    internal var gridController: GridController!
    internal var currentSession: Session! {
        didSet {
            if currentSession != nil {
                gridController?.currentSession = currentSession
            }
        }
    }
    internal var dataManager = DataManager()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopNav()
        setUpGrid()
        setUpSidePane()
        setUpAnimationDesigner()
        setUpStyles()
        setUpAnimation()

        // need assign delegates after everything is initialized
        gridController.padDelegate = sidePaneController
    }

    // Sets up the top navigation.
    // The top navigation has controls to show the session table, so we set that up here as well.
    private func setUpTopNav() {
        sessionTableViewController = SessionTableViewController(style: .plain)
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
        sessionNavigationController = UINavigationController(rootViewController: sessionTableViewController)
        // present the session table as a popover
        sessionNavigationController.modalPresentationStyle = .popover
        sessionTableViewController.delegate = self

        let navFrame = CGRect(origin: CGPoint.zero,
                              size: CGSize(width: view.frame.width, height: Config.TopNavHeight))
        topBarController = TopBarController(frame: navFrame)

        topBarController.modeSwitchDelegate = self
        topBarController.sessionSelectorDelegate = self
        topBarController.setTargetActionOfSaveButton(target: self, selector: #selector(saveCurrentSession))

        view.addSubview(topBarController.view)
    }

    // Saves the current session
    func saveCurrentSession() {
        currentSession = dataManager.saveSession(Config.DefaultSessionName, currentSession)
    }

    // Tries to load a session, if no sessions exists then returns nil
    private func loadFirstSessionIfExsists() -> Session? {
        func loadTillSuccessOrEnd(names: [String]) -> Session? {
            guard let name = names.first else {
                return nil
            }

            if let session = dataManager.loadSession(name) {
                return session
            } else {
                let tail = Array(names.suffix(0))
                return loadTillSuccessOrEnd(names: tail)
            }
        }
        return loadTillSuccessOrEnd(names: dataManager.loadAllSessionNames())
    }

    // Sets up the main grid for play/edit
    private func setUpGrid() {
        let frame = view.frame
        let gridFrame = CGRect(x: frame.minX + Config.AppLeftPadding,
                           y: frame.height * Config.MainViewHeightToGridMinYRatio,
                           width: frame.width - Config.AppLeftPadding - Config.AppRightPadding,
                           height: frame.height * Config.MainViewHeightToGridHeightRatio)
        currentSession = loadFirstSessionIfExsists() ?? Session(bpm: Config.defaultBPM)
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

    private func setUpAnimationDesigner() {
        animationDesignController = AnimationDesignerController()
        animationDesignController.view.frame =
            CGRect(x: view.frame.minX + Config.AppLeftPadding,
                   y: view.frame.height * Config.MainViewHeightToAnimMinYRatio,
                   width: view.frame.width * Config.MainViewWidthToAnimWidthRatio,
                   height: view.frame.height * Config.MainViewHeightToAnimHeightRatio)
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

}

// Called when the mode is switch. Passes on the event to the grid and side pane
extension ViewController: ModeSwitchDelegate {
    func enterEdit() {
        gridController.enterEdit()
        view.addSubview(sidePaneController.view)
        view.addSubview(animationDesignController.view)
    }

    func enterPlay() {
        // error handling
        gridController.enterPlay()
        sidePaneController.view.removeFromSuperview()
        animationDesignController.view.removeFromSuperview()
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

extension ViewController: SessionTableDelegate {
    func sessionTable(_: UITableView, didSelect sessionName: String) {
        // try to load session
        let loadedSession = dataManager.loadSession(sessionName)
        if loadedSession == nil {
            // failed to load this session, which is weird since we got the session name from the data manager
            // maybe we can show some error error
        } else {
            // session successfully loaded
            self.currentSession = loadedSession
        }
        sessionNavigationController.dismiss(animated: true, completion: nil)
    }

    func sessionTable(_: UITableView) {
        // create a new blank session
        currentSession = Session(bpm: Config.defaultBPM)
        // save it
        saveCurrentSession()
        // then we reload the session lists in sessionTableViewController
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
        sessionNavigationController.dismiss(animated: true, completion: nil)
    }

    func sessionTable(_: UITableView, didRemove sessionName: String) {
        _ = dataManager.removeSession(sessionName)
    }
}
