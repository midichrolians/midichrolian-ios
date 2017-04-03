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

    internal let sampleList = DataManager.instance.loadAllAudioStrings()

    override init(style: UITableViewStyle) {
        super.init(style: style)

        title = Config.SampleTableTitle
        tabBarItem = UITabBarItem(title: Config.SampleTableTitle,
                                  image: UIImage(named: Config.SidePaneTabBarSampleIcon),
                                  selectedImage: UIImage(named: Config.SidePaneTabBarSampleIcon))
        tableView.separatorStyle = .none
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
        delegate?.sampleTable(tableView, didSelect: sound(for: indexPath))
    }

    private func sound(for indexPath: IndexPath) -> String {
        return sampleList[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.SampleTableCellHeight
    }

}
