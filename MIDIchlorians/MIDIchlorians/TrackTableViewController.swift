//
//  TrackTableViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Controller to manage the list of tracks in editing mode.
class TrackTableViewController: UITableViewController {
    weak var delegate: TrackTableDelegate?

    private let reuseIdentifier = Config.TrackTableReuseIdentifier

    override init(style: UITableViewStyle) {
        super.init(style: style)

        self.title = "Tracks"
        self.tabBarItem = UITabBarItem(title: "Tracks",
                                       image: UIImage(named: Config.SidePaneTabBarTrackIcon),
                                       selectedImage: UIImage(named: Config.SidePaneTabBarTrackIcon))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorColor = Config.TableViewSeparatorColor

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        // #warning Incomplete implementation, return the number of rows
        return Config.sound.reduce(0, { (r, s) in r + s.count })
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath) as? TrackTableViewCell else {
                return TrackTableViewCell()
        }

        cell.set(track: sound(for: indexPath))

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = Config.TrackTableViewCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.trackTable(tableView, didSelect: sound(for: indexPath))
    }

    private func sound(for indexPath: IndexPath) -> String {
        return Config.sound[indexPath.row / Config.sound[0].count][indexPath.row % Config.sound[0].count]
    }

}
