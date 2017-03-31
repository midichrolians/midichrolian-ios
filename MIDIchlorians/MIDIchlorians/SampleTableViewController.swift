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

    private let newSampleButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    private let reuseIdentifier = Config.SampleTableReuseIdentifier
    private let sampleList = DataManager.instance.loadAllAudioStrings()

    internal let sampleList = DataManager.instance.loadAllAudioStrings()

    override init(style: UITableViewStyle) {
        super.init(style: style)

        title = Config.SampleTableTitle
        tabBarItem = UITabBarItem(title: Config.SampleTableTitle,
                                  image: UIImage(named: Config.SidePaneTabBarSampleIcon),
                                  selectedImage: UIImage(named: Config.SidePaneTabBarSampleIcon))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorColor = Config.TableViewSeparatorColor

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.newSampleButton
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

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = Config.SampleTableViewCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sampleTable(tableView, didSelect: sound(for: indexPath))
    }

    private func sound(for indexPath: IndexPath) -> String {
        return sampleList[indexPath.row]
    }

}
