//
//  ViewController.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import RealmSwift
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
    internal var sessionTableViewController: SessionTableViewController!
    internal var sidePaneController: SidePaneController!
    internal var animationDesignController: AnimationDesignerController!
    internal var sampleSettingController: SampleSettingViewController!
    internal var gridController: GridController!
    internal var currentSession: Session! {
        didSet {
            if currentSession != nil {
                gridController?.currentSession = currentSession
            }
        }
    }
    private let cloudManager = CloudManager.instance
    internal var dataManager = DataManager.instance

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentSession = loadFirstSessionIfExsists() ?? Session(bpm: Config.defaultBPM)
        setUpTopNav()
        setUpGrid()
        setUpSidePane()
        setUpSampleSetting()
        setUpAnimationDesigner()
        setUpStyles()
        setUpAnimation()

        // need assign delegates after everything is initialized
        gridController.padDelegate = self
        animationDesignController.delegate = gridController
        gridController.animationDesignerDelegate = sidePaneController
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

        // handle completion of syncing sessions
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(notification:)),
                                               name: NSNotification.Name(rawValue: Config.sessionNotificationKey),
                                               object: nil)

        topBarController = TopBarController()
        addChildViewController(topBarController)
        view.addSubview(topBarController.view)
        topBarController.didMove(toParentViewController: self)

        topBarController.view.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.height.equalTo(Config.TopNavHeight)
        }

        topBarController.modeSwitchDelegate = self
        topBarController.sessionSelectorDelegate = self
        topBarController.syncDelegate = self
        topBarController.setTargetActionOfSaveButton(target: self, selector: #selector(saveCurrentSession))
        topBarController.setSession(to: currentSession)
    }

    // Saves the current session
    func saveCurrentSession() {
        currentSession = dataManager.saveSession(
            currentSession.getSessionName() ?? Config.DefaultSessionName, currentSession)
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
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
        gridController = GridController(frame: CGRect.zero, session: currentSession)
        addChildViewController(gridController)
        view.addSubview(gridController.view)
        gridController.didMove(toParentViewController: self)

        gridController.view.snp.makeConstraints { make in
            make.top.equalTo(topBarController.view.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }

    // Sets up the side pane with controls for samples and animations
    private func setUpSidePane() {
        sidePaneController = SidePaneController()
        sidePaneController.sampleTableDelegate = gridController
        sidePaneController.animationTableDelegate = self
        sidePaneController.delegate = self

        view.addSubview(sidePaneController.view)
        sidePaneController.view.snp.makeConstraints { make in
            make.width.equalTo(Config.SidePaneWidth)
            make.left.equalTo(gridController.view.snp.right)
            make.top.equalTo(topBarController.view.snp.bottom)
            make.bottom.equalTo(view)
        }
    }

    private func setUpSampleSetting() {
        sampleSettingController = SampleSettingViewController()
        sampleSettingController.view.backgroundColor = Config.SecondaryBackgroundColor
        sampleSettingController.delegate = gridController
        addChildViewController(sampleSettingController)
        view.addSubview(sampleSettingController.view)
        didMove(toParentViewController: self)

        sampleSettingController.view.snp.makeConstraints { make in
            make.height.equalTo(Config.BottomPaneHeight)
            make.left.equalTo(view)
            make.right.equalTo(sidePaneController.view.snp.left)
            make.top.equalTo(view.snp.bottom).offset(0)
        }
    }

    private func setUpAnimationDesigner() {
        animationDesignController = AnimationDesignerController()
        animationDesignController.view.backgroundColor = Config.SecondaryBackgroundColor
        addChildViewController(animationDesignController)
        view.addSubview(animationDesignController.view)
        animationDesignController.didMove(toParentViewController: self)

        animationDesignController.view.snp.makeConstraints { make in
            make.height.equalTo(Config.BottomPaneHeight)
            make.left.equalTo(view)
            make.right.equalTo(sidePaneController.view.snp.left)
            make.top.equalTo(view.snp.bottom).offset(0)
        }
    }

    // Sets up application wide styles
    private func setUpStyles() {
        view.backgroundColor = Config.BackgroundColor

        // proxy to make all table views have the same background color
        UITableView.appearance().backgroundColor = Config.SecondaryBackgroundColor
        UITableViewCell.appearance().backgroundColor = Config.SecondaryBackgroundColor
    }

    // Sets up the animation engine
    private func setUpAnimation() {
        AnimationEngine.set(animationGrid: gridController.gridCollectionView)
        AnimationEngine.set(beatsPerMinute: Config.defaultBPM)
        AnimationEngine.start()
    }

    internal func showSampleSettingPane() {
        sampleSettingController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-Config.BottomPaneHeight)
        }
        animationDesignController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(0)
        }
    }

    internal func showAnimationDesignPane() {
        sampleSettingController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(0)
        }
        animationDesignController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-Config.BottomPaneHeight)
        }
    }

    internal func hideBottomPane() {
        sampleSettingController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(0)
        }
        animationDesignController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(0)
        }
    }

    // Update session table with new sessions after downloading
    func handle(notification: Notification) {
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
    }
}

// Called when the mode is switch. Passes on the event to the grid and side pane
extension ViewController: ModeSwitchDelegate {
    func enterEdit() {
        gridController.view.snp.updateConstraints { make in
            make.right.equalTo(view).offset(-Config.SidePaneWidth)
        }
        showSampleSettingPane()
        gridController.enterEdit()
    }

    func enterPlay() {
        // error handling
        gridController.view.snp.updateConstraints { make in
            make.right.equalTo(view).offset(0)
        }
        hideBottomPane()
        gridController.enterPlay()
    }

    func enterDesign() {
        showAnimationDesignPane()
        gridController.enterDesign()
        animationDesignController.enterDesign()
        self.pad(animationUpdated: gridController.animationSequence)
    }
}

// Called when session selector is tapped, shows the sessions as a popover
extension ViewController: SessionSelectorDelegate {
    func sessionSelector(sender: UIButton) {
        present(sessionNavigationController, animated: false, completion: nil)

        // configure styles and anchor of popover presentation controller
        let popoverPresentationController = sessionNavigationController.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = [.up]
        popoverPresentationController?.sourceView = sender
        popoverPresentationController?.sourceRect = CGRect(
            x: sender.frame.midX, y: sender.frame.maxY, width: 0, height: 0)
        popoverPresentationController?.backgroundColor = Config.SecondaryBackgroundColor
    }
}

extension ViewController: AnimationTableDelegate {
    func animationTable(_ tableView: UITableView, didSelect animation: String) {
        gridController.animationTable(tableView, didSelect: animation)
    }

    func addAnimation(_ tableView: UITableView) {
        gridController.selectedIndexPath = gridController.selectedIndexPath ?? IndexPath(row: 0, section: 0)
        animationDesignController.selectedFrame = IndexPath(row: 0, section: 0)
        self.enterDesign()
    }
}

extension ViewController: SidePaneDelegate {
    func sidePaneSelectSample() {
        showSampleSettingPane()
        // set the mode back to editing so the animation views and styles will be cleared
        gridController.mode = .editing
    }
}

extension ViewController: SessionTableDelegate {
    func sessionTable(_: UITableView, didSelect sessionName: String) {
        guard let loadedSession = dataManager.loadSession(sessionName) else {
            // failed to load this session, which is weird since we got the session name from the data manager
            // maybe we can show some error error
            return
        }
        self.currentSession = loadedSession
        topBarController.setSession(to: currentSession)
        sessionNavigationController.dismiss(animated: true, completion: nil)
    }

    func sessionTable(_: UITableView) {
        // if the name already exist we want to create one with different name
        // the convention is to use the default name with the smallest possible numeric suffix
        var count = 0
        func newUnusedName(suffix: String) -> String {
            // we add the space to the suffix in the recursive call so that
            // the first call will not have an extranaeous space
            let name = "\(Config.DefaultSessionName)\(suffix)"
            let defaultSession = dataManager.loadSession(name)
            if defaultSession == nil {
                return name
            } else {
                count += 1
                return newUnusedName(suffix: " \(String(count))")
            }
        }
        let name = newUnusedName(suffix: "")
        currentSession = Session(bpm: Config.defaultBPM)
        _ = dataManager.saveSession(name, currentSession)
        topBarController.setSession(to: currentSession)
        // then we reload the session lists in sessionTableViewController
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
        sessionNavigationController.dismiss(animated: true, completion: nil)
    }

    func sessionTable(_: UITableView, didRemove sessionName: String) {
        _ = dataManager.removeSession(sessionName)
    }

    func sessionTable(_: UITableView, didChange oldSessionName: String, to newSessionName: String) {
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
        topBarController.setSession(to: currentSession)
    }
}

extension ViewController: PadDelegate {
    func padTapped(indexPath: IndexPath) {
        sidePaneController.padTapped(indexPath: indexPath)
    }

    func pad(selected: Pad) {
        sidePaneController.pad(selected: selected)
    }

    func pad(played: Pad) {
        sidePaneController.pad(played: played)
    }

    func pad(animationUpdated animation: AnimationSequence) {
        animationDesignController.pad(animationUpdated: animation)
    }

}

extension ViewController: SyncDelegate {
    // Loads the dropbox authentication
    func loadDropboxWebView() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url) },
                                                      browserAuth: true)
    }
}
