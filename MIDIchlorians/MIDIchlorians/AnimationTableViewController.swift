//
//  AnimationTableViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Controller to manage the list of animations in editing mode.
class AnimationTableViewController: UITableViewController {
    weak var delegate: AnimationTableDelegate?

    internal var animationTypeNames = AnimationManager.instance.getAllAnimationTypesNames().sorted()

    private let reuseIdentifier = Config.animationTableReuseIdentifier
    private let newAnimationButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    private var editAlert = UIAlertController(title: Config.animationEditAlertTitle,
                                              message: nil,
                                              preferredStyle: .alert)
    internal var alertSaveAction: UIAlertAction!
    private var alertCancelAction: UIAlertAction!
    private var editingIndexPath: IndexPath?
    private var rowEditAction: UITableViewRowAction!
    private var rowRemoveAction: UITableViewRowAction!
    private var removeAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    private var removeAlertConfirmAction: UIAlertAction!
    private var removeAlertCancelAction: UIAlertAction!
    private var actionTextSync: AlertActionTextFieldSync!

    override init(style: UITableViewStyle) {
        super.init(style: style)

        setUp()
        setUpAlert()
        setUpEditActions()
        setUpTargetAction()
        setUpNotificationHandler()
    }

    private func setUp() {
        title = Config.animationTabTitle
        tabBarItem = UITabBarItem(title: Config.animationTabTitle,
                                       image: UIImage(named: Config.sidePaneTabBarAnimationIcon),
                                       selectedImage: UIImage(named: Config.sidePaneTabBarAnimationIcon))
        tableView.separatorStyle = .none
        tableView.separatorColor = Config.tableViewSeparatorColor
        tableView.register(AnimationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.accessibilityLabel = Config.animationTableA11YLabel

        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.leftBarButtonItem = self.newAnimationButton

        refreshControl = UIRefreshControl()
    }

    private func setUpAlert() {
        // Set up alert shown when editing a row
        alertSaveAction = UIAlertAction(title: Config.animationEditOkayTitle,
                                        style: .default,
                                        handler: saveActionDone)
        alertCancelAction = UIAlertAction(title: Config.animationEditCancelTitle,
                                          style: .cancel,
                                          handler: cancelActionDone)
        editAlert.addAction(alertCancelAction)
        editAlert.addAction(alertSaveAction)

        // Set up alert shown when removing a row
        removeAlertConfirmAction = UIAlertAction(title: Config.animationRemoveConfirmTitle,
                                                 style: .destructive,
                                                 handler: confirmActionDone)
        removeAlertCancelAction = UIAlertAction(title: Config.animationRemoveCancelTitle,
                                                style: .cancel,
                                                handler: cancelActionDone)
        removeAlert.addAction(removeAlertConfirmAction)
        removeAlert.addAction(removeAlertCancelAction)
        actionTextSync = AlertActionTextFieldSync(alertAction: alertSaveAction)
    }

    private func setUpEditActions() {
        rowEditAction = UITableViewRowAction(style: .normal,
                                             title: Config.animationEditActionTitle,
                                             handler: editAction)
        rowRemoveAction = UITableViewRowAction(style: .destructive,
                                               title: Config.animationRemoveActionTitle,
                                               handler: removeAction)
    }

    private func setUpTargetAction() {
        newAnimationButton.target = self
        newAnimationButton.action = #selector(newAnimation)
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    private func setUpNotificationHandler() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(notification:)),
                                               name: NSNotification.Name(rawValue: Config.animationNotificationKey),
                                               object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animationTypeNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as? AnimationTableViewCell else {
                return AnimationTableViewCell()
        }

        cell.textLabel?.text = animationTypeNames[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = Config.animationTableViewCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.animationTable(tableView, didSelect: animationType(at: indexPath))
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.animationTableCellHeight
    }

    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [rowRemoveAction, rowEditAction]
    }

    // Show alert to allow user to edit animation name
    func editAction(_: UITableViewRowAction, _ indexPath: IndexPath) {
        editingIndexPath = indexPath
        editAlert.textFields?.first?.text = animationType(at: indexPath)
        present(editAlert, animated: true, completion: nil)
    }

    // Show alert to confirm deletion
    func removeAction(_: UITableViewRowAction, _ indexPath: IndexPath) {
        editingIndexPath = indexPath
        let title = String(format: Config.animationRemoveTitleFormat, animationType(at: indexPath))
        removeAlert.title = title
        present(removeAlert, animated: true, completion: nil)
    }

    func saveActionDone(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        let animationName = animationType(at: indexPath)
        guard let newName = editAlert.textFields?.first?.text else {
            return
        }
        let updated = AnimationManager.instance.editAnimationTypeName(oldName: animationName, newName: newName)
        if updated {
            // successfully updated, so we can update the model as well
            animationTypeNames[indexPath.row] = newName
        } else {
            // failed to update for some reason, maybe it's because our data is stale, reload
            reloadAnimationNames()
        }
        editingIndexPath = nil
        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func cancelActionDone(_: UIAlertAction) {
        tableView.setEditing(false, animated: true)
    }

    func confirmActionDone(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        let animationName = animationTypeNames.remove(at: indexPath.row)
        _ = AnimationManager.instance.removeAnimationType(name: animationName)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    private func animationType(at indexPath: IndexPath) -> String {
        return animationTypeNames[indexPath.row]
    }

    func newAnimation() {
        delegate?.addAnimation(tableView)
    }

    func refresh() {
        reloadAnimationNames()
        refreshControl?.endRefreshing()
    }

    // Reload animation names from animation manager, and reload data for table view
    private func reloadAnimationNames() {
        animationTypeNames = AnimationManager.instance.getAllAnimationTypesNames().sorted()
        tableView.reloadData()
    }

    // Update animation table with new animations after downloading
    func handle(notification: Notification) {
        guard let success = notification.userInfo?["success"] as? Bool else {
            return
        }
        if success {
            reloadAnimationNames()
        }
    }

}
