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

    internal var animationTypeNames = AnimationManager.instance.getAllAnimationTypesNames()

    private let reuseIdentifier = Config.AnimationTableReuseIdentifier
    private let newAnimationButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    private var alert = UIAlertController(title: Config.AnimationEditAlertTitle, message: nil, preferredStyle: .alert)
    internal var alertSaveAction: UIAlertAction!
    private var alertCancelAction: UIAlertAction!
    private var editingIndexPath: IndexPath?
    private var rowEditAction: UITableViewRowAction!
    private var rowRemoveAction: UITableViewRowAction!

    override init(style: UITableViewStyle) {
        super.init(style: style)

        self.title = Config.AnimationTabTitle

        self.tabBarItem = UITabBarItem(title: Config.AnimationTabTitle,
                                       image: UIImage(named: Config.SidePaneTabBarAnimationIcon),
                                       selectedImage: UIImage(named: Config.SidePaneTabBarAnimationIcon))
        tableView.separatorStyle = .none

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        alertSaveAction = UIAlertAction(title: Config.AnimationEditOkayTitle, style: .default, handler: saveActionDone)
        alertCancelAction = UIAlertAction(title: Config.AnimationEditCancelTitle,
                                          style: .cancel,
                                          handler: editActionCancel)
        alert.addAction(alertCancelAction)
        alert.addAction(alertSaveAction)
        alert.addTextField(configurationHandler: { $0.delegate = self })

        rowEditAction = UITableViewRowAction(style: .normal,
                                             title: Config.AnimationEditActionTitle,
                                             handler: edit)
        rowRemoveAction = UITableViewRowAction(style: .destructive,
                                               title: Config.AnimationRemoveActionTitle,
                                               handler: removeAnimation)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorColor = Config.TableViewSeparatorColor
        self.tableView.register(AnimationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.newAnimationButton
        newAnimationButton.target = self
        newAnimationButton.action = #selector(newAnimation)
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
        cell.textLabel?.textColor = Config.AnimationTableViewCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.animationTable(tableView, didSelect: animationType(at: indexPath))
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.AnimationTableCellHeight
    }

    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [rowRemoveAction, rowEditAction]
    }

    // Show alert to allow user to edit animation name
    func edit(_: UITableViewRowAction, _ indexPath: IndexPath) {
        editingIndexPath = indexPath
        alert.textFields?.first?.text = animationType(at: indexPath)
        present(alert, animated: true, completion: nil)
    }

    func saveActionDone(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        let animationName = animationType(at: indexPath)
        guard let newName = alert.textFields?.first?.text else {
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

    func editActionCancel(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        editingIndexPath = nil
        // clear the swipe actions
        tableView.reloadRows(at: [indexPath], with: .right)
    }

    func removeAnimation(_: UITableViewRowAction, _ indexPath: IndexPath) {
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
        animationTypeNames = AnimationManager.instance.getAllAnimationTypesNames()
        tableView.reloadData()
    }

}

extension AnimationTableViewController: UITextFieldDelegate {
    // Don't allow return if the field is empty, user must explicitly cancel
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return !(textField.text?.isEmpty ?? true)
    }

    // Deactivate the Save button if text field is empty
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }

        let str = (text as NSString).replacingCharacters(in: range, with: string)
        if str.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            alertSaveAction.isEnabled = false
        } else {
            alertSaveAction.isEnabled = true
        }
        return true
    }
}
