//
//  SampleTableViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Controller to manage the list of samples in editing mode.
class SampleTableViewController: UITableViewController {
    weak var delegate: SampleTableDelegate?
    var group: String? {
        didSet {
            title = group
        }
    }

    private let reuseIdentifier = Config.SampleTableReuseIdentifier

    internal var sampleList: [String] = []
    var selectedSampleName: String?

    private var editingIndexPath: IndexPath?
    private var removeAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    private var removeAlertConfirmAction: UIAlertAction!
    private var removeAlertCancelAction: UIAlertAction!

    private var leftGroupBarButton: UIBarButtonItem!
    private var rightDoneBarButton: UIBarButtonItem!

    override init(style: UITableViewStyle) {
        super.init(style: style)

        tableView.separatorStyle = .none
        tableView.accessibilityLabel = "Sample Table"

        removeAlertConfirmAction = UIAlertAction(title: Config.SampleRemoveConfirmTitle,
                                                 style: .destructive,
                                                 handler: confirmActionDone)
        removeAlertCancelAction = UIAlertAction(title: Config.SampleRemoveCancelTitle,
                                                style: .cancel,
                                                handler: cancelActionDone)
        removeAlert.addAction(removeAlertConfirmAction)
        removeAlert.addAction(removeAlertCancelAction)
        // set up handler for sync
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(notification:)),
                                               name: NSNotification.Name(rawValue: Config.audioNotificationKey),
                                               object: nil)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        tableView.addGestureRecognizer(longPress)

        leftGroupBarButton = UIBarButtonItem(title: "Group", style: .done, target: self, action: #selector(group(_:)))
        rightDoneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }

    // Show a popup to allow user to select stuff
    func group(_ sender: UIBarButtonItem) {
        let group = GroupTableViewController(style: .plain)
        group.preferredContentSize = CGSize(width: 300, height: 300)
        group.modalPresentationStyle = .popover
        group.groupTableDelegate = self
        present(group, animated: true, completion: nil)

        let popover = group.popoverPresentationController
        popover?.barButtonItem = sender
    }

    // Exit grouping
    func done() {
        tableView.deselectAll()
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = false
        navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // When we enter a long press state, we shall go into grouping mode to allow user to
    // select multiple samples and send them all into a group
    func longPress(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .ended {
            tableView.allowsMultipleSelection = true
            let point = recognizer.location(in: tableView!)
            guard let indexPath = tableView.indexPathForRow(at: point) else {
                return
            }
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)

            navigationItem.hidesBackButton = true
            navigationItem.setLeftBarButton(leftGroupBarButton, animated: true)
            navigationItem.setRightBarButton(rightDoneBarButton, animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorColor = Config.TableViewSeparatorColor

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.highlightSelected()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath) as? SampleTableViewCell else {
                return SampleTableViewCell()
        }

        cell.set(sample: sound(for: indexPath))
        cell.playButton.addTarget(self, action: #selector(playButtonPressed(button:)), for: .touchDown)
        // Save the row so we know which sample to play
        cell.playButton.tag = indexPath.row

        return cell
    }

    // Play the sample sound
    func playButtonPressed(button: UIButton) {
        let row = button.tag
        _ = AudioManager.instance.play(audioDir: sampleList[row])
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = Config.SampleTableViewCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSampleName = sound(for: indexPath)
        delegate?.sampleTable(tableView, didSelect: sound(for: indexPath))
        for vc in self.navigationController?.viewControllers ?? [] {
            if let vc = vc as? GroupTableViewController {
                vc.selectedGroupName = title
            }
        }
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            editingIndexPath = indexPath
            let title = String(format: Config.SampleRemoveTitleFormat, sound(for: indexPath))
            removeAlert.title = title
            present(removeAlert, animated: true, completion: nil)
        }
    }

    func cancelActionDone(_: UIAlertAction) {
        tableView.setEditing(false, animated: true)
    }

    func confirmActionDone(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        let sample = sampleList.remove(at: indexPath.row)
        // remove from file system too?
        _ = DataManager.instance.removeAudio(sample)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    fileprivate func sound(for indexPath: IndexPath) -> String {
        return sampleList[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.SampleTableCellHeight
    }

    func unhighlight() {
        tableView.deselectAll()
    }

    func highlightSelected() {
        guard let sel = selectedSampleName, let index = sampleList.index(of: sel) else {
            return unhighlight()
        }

        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }

    // Handle notification from dropbox download
    func handle(notification: Notification) {
        guard let success = notification.userInfo?["success"] as? Bool else {
            return
        }
        if success {
            refresh()
        }
    }

    fileprivate func refresh() {
        guard let group = group else {
            return
        }
        sampleList = DataManager.instance.getSamplesForGroup(group: group).sorted()
        tableView.reloadData()
    }

}

extension SampleTableViewController: GroupTableDelegate {
    func group(selected group: String) {
        // group all songs
        guard let indexPaths = tableView.indexPathsForSelectedRows else {
            return
        }
        for indexPath in indexPaths {
            let sample = sound(for: indexPath)
            _ = DataManager.instance.addSampleToGroup(group: group, sample: sample)
        }
        // refresh the sample list
        refresh()
        done()
        // dismiss the group popover
        dismiss(animated: true, completion: nil)
    }
}
