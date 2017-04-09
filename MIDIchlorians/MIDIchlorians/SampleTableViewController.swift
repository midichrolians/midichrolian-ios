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

    private let reuseIdentifier = Config.SampleTableReuseIdentifier

    internal var sampleList: [String] = []
    var selectedSampleName: String?

    private var editingIndexPath: IndexPath?
    private var removeAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    private var removeAlertConfirmAction: UIAlertAction!
    private var removeAlertCancelAction: UIAlertAction!

    override init(style: UITableViewStyle) {
        super.init(style: style)

        title = Config.SampleTableTitle

        tableView.separatorStyle = .none

        removeAlertConfirmAction = UIAlertAction(title: Config.SampleRemoveConfirmTitle,
                                                 style: .destructive,
                                                 handler: confirmActionDone)
        removeAlertCancelAction = UIAlertAction(title: Config.SampleRemoveCancelTitle,
                                                style: .cancel,
                                                handler: cancelActionDone)
        removeAlert.addAction(removeAlertConfirmAction)
        removeAlert.addAction(removeAlertCancelAction)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorColor = Config.TableViewSeparatorColor

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        if let name = selectedSampleName {
            self.highlight(sample: name)
        }
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
        self.selectedSampleName = sound(for: indexPath)
        delegate?.sampleTable(tableView, didSelect: sound(for: indexPath))
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            editingIndexPath = indexPath
            let title = String(format: Config.SampleRemoveTitleFormat, sound(for: indexPath))
            removeAlert.title = title
            present(removeAlert, animated: true, completion: nil)
        }
    }

    func cancelActionDone(_: UIAlertAction) {
        tableView.setEditing(false, animated: true)
    }

    func confirmActionDone(_: UIAlertAction) {
        guard let indexPath = editingIndexPath else {
            return
        }
        let sample = sampleList.remove(at: indexPath.row)
        // remove from file system too?
        _ = DataManager.instance.removeAudio(sample)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    private func sound(for indexPath: IndexPath) -> String {
        return sampleList[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.SampleTableCellHeight
    }

    func unhighlight() {
        tableView.deselectAll()
    }

    func highlight(sample: String) {
        guard let index = sampleList.index(of: sample) else {
            return unhighlight()
        }

        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }

}
