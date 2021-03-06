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

// The ViewController is the main for the entire app.
// Management and hooking up all child view controllers are done in this class.
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
                topBarController?.setSession(to: currentSession)
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

        ensureSessionLoaded()
        setUpUI()
        assignDelegates()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isFirstLaunch() {
            topBarController.logoTapped()
        }
    }

    // Many things rely on a session being loaded, so make sure we have one
    private func ensureSessionLoaded() {
        currentSession = (loadFirstSessionIfExists() ?? Session(bpm: Config.defaultBPM))
    }

    // Sets up all the UI components needed for the app
    private func setUpUI() {
        setUpTopNav()
        setUpGrid()
        setUpSidePane()
        setUpSampleSetting()
        setUpAnimationDesigner()
        setUpStyles()
        setUpAnimation()
    }

    private func assignDelegates() {
        // need assign these delegates after everything is initialized
        animationDesignController.delegate = gridController
        gridController.animationDesignerDelegate = sidePaneController
    }

    // Sets up the top navigation.
    // The top navigation has controls to show the session table, so we set that up here as well.
    private func setUpTopNav() {
        setUpSessionTable()
        setUpNotificationHandler()
        setUpTopBarController()
    }

    private func setUpSessionTable() {
        sessionTableViewController = SessionTableViewController(style: .plain)
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
        sessionNavigationController = UINavigationController(rootViewController: sessionTableViewController)
        // present the session table as a popover
        sessionNavigationController.modalPresentationStyle = .popover
        sessionTableViewController.delegate = self
    }

    private func setUpNotificationHandler() {
        // handle completion of syncing sessions
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(notification:)),
                                               name: NSNotification.Name(rawValue: Config.sessionNotificationKey),
                                               object: nil)

    }

    private func setUpTopBarController() {
        topBarController = TopBarController()
        addChildViewController(topBarController)
        view.addSubview(topBarController.view)
        topBarController.didMove(toParentViewController: self)

        topBarController.view.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.height.equalTo(Config.topNavHeight)
        }

        topBarController.modeSwitchDelegate = self
        topBarController.sessionSelectorDelegate = self
        topBarController.syncDelegate = self
        topBarController.setTargetActionOfSaveButton(target: self, selector: #selector(saveCurrentSession))
        topBarController.setSession(to: currentSession)
    }

    // Saves the current session
    func saveCurrentSession() {
        let sessionName = currentSession.getSessionName() ?? Config.defaultSessionName
        currentSession = dataManager.saveSession(sessionName, currentSession)
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
    }

    // Tries to load a session, if no sessions exists then returns nil
    private func loadFirstSessionIfExists() -> Session? {
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
        gridController.padDelegate = self
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
            make.width.equalTo(Config.sidePaneWidth)
            make.left.equalTo(gridController.view.snp.right)
            make.top.equalTo(topBarController.view.snp.bottom)
            make.bottom.equalTo(view)
        }
    }

    // Sets up the bottom panel for editing sample settings
    private func setUpSampleSetting() {
        sampleSettingController = SampleSettingViewController()
        sampleSettingController.view.backgroundColor = Config.secondaryBackgroundColor
        sampleSettingController.delegate = gridController
        sampleSettingController.bpmSelectorDelegate = self
        addChildViewController(sampleSettingController)
        view.addSubview(sampleSettingController.view)
        didMove(toParentViewController: self)

        sampleSettingController.view.snp.makeConstraints { make in
            make.height.equalTo(Config.bottomPaneHeight)
            make.left.equalTo(view)
            make.right.equalTo(sidePaneController.view.snp.left)
            make.top.equalTo(view.snp.bottom).offset(0)
        }
    }

    // Sets up the bottom panel for designing animations
    private func setUpAnimationDesigner() {
        animationDesignController = AnimationDesignerController()
        animationDesignController.view.backgroundColor = Config.secondaryBackgroundColor
        addChildViewController(animationDesignController)
        view.addSubview(animationDesignController.view)
        animationDesignController.didMove(toParentViewController: self)

        animationDesignController.view.snp.makeConstraints { make in
            make.height.equalTo(Config.bottomPaneHeight)
            make.left.equalTo(view)
            make.right.equalTo(sidePaneController.view.snp.left)
            make.top.equalTo(view.snp.bottom).offset(0)
        }
    }

    // Sets up application wide styles
    private func setUpStyles() {
        view.backgroundColor = Config.backgroundColor

        // proxy to make all table views have the same background color
        UITableView.appearance().backgroundColor = Config.secondaryBackgroundColor
        UITableViewCell.appearance().backgroundColor = Config.secondaryBackgroundColor
    }

    // Sets up the animation engine
    private func setUpAnimation() {
        AnimationEngine.set(animationGrid: gridController.gridCollectionView)
        AnimationEngine.set(beatsPerMinute: Config.defaultBPM)
        AnimationEngine.start()
    }

    // Helper function to update constraints to show sample setting panel
    internal func showSampleSettingPane() {
        sampleSettingController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-Config.bottomPaneHeight)
        }
        animationDesignController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(0)
        }
    }

    // Helper function to update constraints to show animation design panel
    internal func showAnimationDesignPane() {
        sampleSettingController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(0)
        }
        animationDesignController.view.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-Config.bottomPaneHeight)
        }
    }

    // Helper function to update constraints to hide bottom panels
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

    private func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: Config.hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: Config.hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

// Called when the mode is switch. Passes on the event to the grid and side pane
extension ViewController: ModeSwitchDelegate {
    func enterEdit() {
        gridController.view.snp.updateConstraints { make in
            make.right.equalTo(view).offset(-Config.sidePaneWidth)
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
        popoverPresentationController?.backgroundColor = Config.secondaryBackgroundColor
    }
}

// Called when an animation is selected from the animation table
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

// Called when a tab is selected in the side pane
extension ViewController: SidePaneDelegate {
    func sidePaneSelectSample() {
        showSampleSettingPane()
        // set the mode back to editing so the animation views and styles will be cleared
        gridController.mode = .editing
    }
}

// Called when an event happens on the session table
extension ViewController: SessionTableDelegate {
    func sessionTable(_: UITableView, didSelect sessionName: String) {
        guard let loadedSession = dataManager.loadSession(sessionName) else {
            // failed to load this session, which is weird since we got the session name from the data manager
            // maybe we can show some error error
            return
        }
        self.currentSession = loadedSession
        sessionNavigationController.dismiss(animated: true, completion: nil)
    }

    func sessionTable(_: UITableView) {
        // if the name already exist we want to create one with different name
        // the convention is to use the default name with the smallest possible numeric suffix
        var count = 0
        func newUnusedName(suffix: String) -> String {
            // we add the space to the suffix in the recursive call so that
            // the first call will not have an extranaeous space
            let name = "\(Config.defaultSessionName)\(suffix)"
            let defaultSession = dataManager.loadSession(name)
            if defaultSession == nil {
                return name
            } else {
                count += 1
                return newUnusedName(suffix: " \(String(count))")
            }
        }
        let name = newUnusedName(suffix: "")
        currentSession = dataManager.saveSession(name, Session(bpm: Config.defaultBPM))
        // then we reload the session lists in sessionTableViewController
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
        sessionNavigationController.dismiss(animated: true, completion: nil)
    }

    func sessionTable(_: UITableView, didRemove sessionName: String) {
        _ = dataManager.removeSession(sessionName)
    }

    func sessionTable(_: UITableView, didChange oldSessionName: String, to newSessionName: String) {
        sessionTableViewController.sessions = dataManager.loadAllSessionNames()
        currentSession = dataManager.loadSession(newSessionName)
    }
}

// Called when a pad in the grid is tapped
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

// Called by sync manager to initiate syncing to dropbox
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

// Called when the bpm for a sample is changed
extension ViewController: BPMSelectorDelegate {
    func bpm(selected bpm: Int) {
        currentSession.setSessionBPM(bpm: bpm)
        print(currentSession.getSessionBPM())
    }
}
