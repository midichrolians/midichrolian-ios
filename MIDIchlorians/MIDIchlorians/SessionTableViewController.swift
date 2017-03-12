//
//  SessionTableViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 12/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class SessionTableViewController: UITableViewController {
    weak var delegate: SessionTableDelegate?

    private let data = ["Session 1", "Session 2"]
    private let reuseIdentifier = Config.SessionTableReuseIdentifier

    override init(style: UITableViewStyle) {
        super.init(style: style)

        self.title = "Sessions"
        self.tabBarItem = UITabBarItem(title: "Sessions",
                                       image: UIImage(named: Config.SidePaneTabBarTrackIcon),
                                       selectedImage: UIImage(named: Config.SidePaneTabBarTrackIcon))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(SessionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as? SessionTableViewCell else {
                return SessionTableViewCell()
        }

        cell.textLabel?.text = data[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = Config.SessionTableViewCellColor
    }

}
