//
//  SessionTableViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 12/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Manages a list of sessions that the user has
class SessionTableViewController: UITableViewController {
    weak var delegate: SessionTableDelegate?

    private var rowEditAction: UITableViewRowAction!
    private var rowRemoveAction: UITableViewRowAction!
    private var editingIndexPath: IndexPath?

    private var editAlert = UIAlertController(title: Config.SessionEditAlertTitle,
                                              message: nil,
                                              preferredStyle: .alert)
    internal var alertSaveAction: UIAlertAction!
    private var alertCancelAction: UIAlertAction!

    private var removeAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    private var removeAlertConfirmAction: UIAlertAction!
    private var removeAlertCancelAction: UIAlertAction!

    var sessions: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let reuseIdentifier = Config.SessionTableReuseIdentifier
    private let newSessionButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    private var longPress: UILongPressGestureRecognizer!
    private var syncAction: AlertActionTextFieldSync!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        setUpTargetAction()
        setUpEditAction()
        setUpAlert()
    }

    func setUp() {
        self.title = Config.SessionTableTitle
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.newSessionButton
        self.tableView.register(SessionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorColor = Config.TableViewSeparatorColor
        self.tableView.accessibilityLabel = "Session Table"
    }

    func setUpTargetAction() {
        self.newSessionButton.target = self
        self.newSessionButton.action = #selector(newSession)
    }

    func setUpEditAction() {
        rowEditAction = UITableViewRowAction(style: .normal,
                                             title: Config.SessionEditActionTitle,
                                             handler: editAction)
        rowRemoveAction = UITableViewRowAction(style: .destructive,
                                               title: Config.SessionRemoveActionTitle,
                                               handler: removeAction)
    }

    func setUpAlert() {
        // Set up alert shown when editing a row
        alertSaveAction = UIAlertAction(
            title: Config.SessionEditOkayTitle, style: .default, handler: saveActionDone)
        alertCancelAction = UIAlertAction(
            title: Config.SessionEditCancelTitle, style: .cancel, handler: cancelActionDone)
        editAlert.addAction(alertCancelAction)
        editAlert.addAction(alertSaveAction)

        syncAction = AlertActionTextFieldSync(alertAction: alertSaveAction)
        editAlert.addTextField(configurationHandler: { $0.delegate = self.syncAction })

        removeAlertConfirmAction = UIAlertAction(
            title: Config.SessionRemoveConfirmTitle, style: .destructive, handler: confirmActionDone)
        removeAlertCancelAction = UIAlertAction(
            title: Config.SessionEditCancelTitle, style: .cancel, handler: cancelActionDone)

        removeAlert.addAction(removeAlertConfirmAction)
        removeAlert.addAction(removeAlertCancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as? SessionTableViewCell else {
                return SessionTableViewCell()
        }

        cell.textLabel?.text = sessions[indexPath.row]

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = Config.SessionTableViewCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sessionTable(tableView, didSelect: sessions[indexPath.row])
    }

    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [rowRemoveAction, rowEditAction]
    }

    // Show alert to allow user to edit session name
    func editAction(_: UITableViewRowAction, _ indexPath: IndexPath) {
        editingIndexPath = indexPath
        editAlert.textFields?.first?.text = sessions[indexPath.row]
        present(editAlert, animated: true, completion: nil)
    }

    // Show alert to confirm deletion
    func removeAction(_: UITableViewRowAction, _ indexPath: IndexPath) {
        editingIndexPath = indexPath
        let title = String(format: Config.SessionRemoveTitleFormat, sessions[indexPath.row])
        removeAlert.title = title
        present(removeAlert, animated: true, completion: nil)
    }

    func saveActionDone(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        let sessionName = sessions[indexPath.row]
        guard let newName = editAlert.textFields?.first?.text else {
            return
        }
        _ = DataManager.instance.editSessionName(oldSessionName: sessionName, newSessionName: newName)
        self.delegate?.sessionTable(self.tableView, didChange: sessionName, to: newName)
    }

    func cancelActionDone(_: UIAlertAction) {
        tableView.setEditing(false, animated: true)
    }

    func confirmActionDone(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        let deletedSession = sessions.remove(at: indexPath.row)
        delegate?.sessionTable(tableView, didRemove: deletedSession)
    }

    func newSession() {
        delegate?.sessionTable(tableView)
    }
}
