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

    internal let animationTypeNames = AnimationManager.instance.getAllAnimationTypesNames()
    private let reuseIdentifier = Config.AnimationTableReuseIdentifier
    private let newAnimationButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.title = Config.AnimationTabTitle
        self.tabBarItem = UITabBarItem(title: Config.AnimationTabTitle,
                                       image: UIImage(named: Config.SidePaneTabBarAnimationIcon),
                                       selectedImage: UIImage(named: Config.SidePaneTabBarAnimationIcon))
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

    private func animationType(at indexPath: IndexPath) -> String {
        return animationTypeNames[indexPath.row]
    }

    func newAnimation() {
        delegate?.addAnimation(tableView)
    }

}
