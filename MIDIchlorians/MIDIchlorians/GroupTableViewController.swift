//
//  GroupTableViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 9/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

protocol GroupTableDelegate: class {
    func group(selected: String)
}

// Manages the groups (of samples) that the user has
// A user might have a lot of samples, and this view allows users to browse all samples by groups
class GroupTableViewController: UITableViewController {
    var groups = DataManager.instance.getAllGroups().sorted()
    private let reuseIdentifier = Config.GroupTableReuseIdentifier
    weak var delegate: SampleTableDelegate?
    var selectedSampleName: String?
    var selectedGroupName: String?
    private var tabBarSampleIcon = UIImage(named: Config.SidePaneTabBarSampleIcon)

    private var alert = UIAlertController(title: Config.GroupAlertTitle, message: nil, preferredStyle: .alert)
    private var cancelAction: UIAlertAction!
    private var okayAction: UIAlertAction!
    private var okayTextSync: AlertActionTextFieldSync!

    weak var groupTableDelegate: GroupTableDelegate?

    override init(style: UITableViewStyle) {
        super.init(style: style)

        setUp()
        setUpAlert()
    }

    func setUp() {
        tabBarItem = UITabBarItem(
            title: Config.SampleTableTitle, image: tabBarSampleIcon, selectedImage: tabBarSampleIcon)
        tableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addSample))
    }

    func setUpAlert() {
        cancelAction = UIAlertAction(title: Config.GroupNameCancelTitle, style: .default, handler: cancelActionDone)
        okayAction = UIAlertAction(title: Config.GroupNameOkayTitle, style: .default, handler: okayActionDone)
        okayAction.isEnabled = false
        okayTextSync = AlertActionTextFieldSync(alertAction: okayAction)
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        alert.addTextField(configurationHandler: { textfield in
            textfield.delegate = self.okayTextSync
        })
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Config.SampleTableTitle
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = groups[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sampleTableViewController = SampleTableViewController(style: .plain)
        let group = groups[indexPath.row]
        groupTableDelegate?.group(selected: group)
        sampleTableViewController.sampleList = DataManager.instance.getSamplesForGroup(group: group)
        sampleTableViewController.delegate = delegate
        sampleTableViewController.selectedSampleName = selectedSampleName
        sampleTableViewController.group = group
        self.navigationController?.pushViewController(sampleTableViewController, animated: true)
    }

    func unhighlight() {
        tableView.deselectAll()
    }

    func highlightSelected () {
        guard let sel = selectedGroupName, let index = groups.index(of: sel) else {
            return unhighlight()
        }
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }

    func addSample() {
        present(alert, animated: true, completion: nil)
    }

    func okayActionDone(_: UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }

    func cancelActionDone(_: UIAlertAction) {
        dismiss(animated: true, completion: nil)
    }
}
