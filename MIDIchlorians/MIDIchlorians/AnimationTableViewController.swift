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

    internal var animationTypeNames = AnimationManager.instance.getAllAnimationTypesNames() {
        didSet {
            tableView.reloadData()
        }
    }

    private let reuseIdentifier = Config.AnimationTableReuseIdentifier
    private let newAnimationButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.title = Config.AnimationTabTitle
        self.tabBarItem = UITabBarItem(title: Config.AnimationTabTitle,
                                       image: UIImage(named: Config.SidePaneTabBarAnimationIcon),
                                       selectedImage: UIImage(named: Config.SidePaneTabBarAnimationIcon))
        tableView.separatorStyle = .none
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let animationName = animationTypeNames.remove(at: indexPath.row)
            _ = DataManager.instance.removeAnimation(animationName)
        }
    }

    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal,
                                              title: Config.AnimationEditActionTitle) { (_, indexPath) in
            self.edit(at: indexPath)
        }
        let removeAction = UITableViewRowAction(style: .destructive,
                                                title: Config.AnimationRemoveActionTitle) { (_, indexPath) in
            self.removeAnimation(at: indexPath)
        }
        return [removeAction, editAction]
    }

    // Show alert to allow user to edit animation name
    func edit(at indexPath: IndexPath) {
        let animationName = animationTypeNames[indexPath.row]
        let alert = UIAlertController(title: Config.AnimationEditAlertTitle, message: nil, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: Config.AnimationEditOkayTitle, style: .default, handler: { _ in
                guard let newName = alert.textFields?.first?.text else {
                    // need to call datamanager to update name
                    // and then reload
                    return
                }
            }))
        alert.addAction(
            UIAlertAction(title: Config.AnimationEditCancelTitle, style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.text = animationName
        })
        present(alert, animated: true, completion: nil)
    }

    func removeAnimation(at indexPath: IndexPath) {
    }

    private func animationType(at indexPath: IndexPath) -> String {
        return animationTypeNames[indexPath.row]
    }

    func newAnimation() {
        delegate?.addAnimation(tableView)
    }

    func refresh() {
        animationTypeNames = AnimationManager.instance.getAllAnimationTypesNames()
        refreshControl?.endRefreshing()
    }

}
