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

    var sessions: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let reuseIdentifier = Config.SessionTableReuseIdentifier
    private let newSessionButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    private var longPress: UILongPressGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Config.SessionTableTitle
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.newSessionButton

        // have to set target/action here for this to work, not above in the inistnatiation.
        self.newSessionButton.target = self
        self.newSessionButton.action = #selector(newSession(barButton:))

        self.tableView.register(SessionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorColor = Config.TableViewSeparatorColor

        // this needs to be set up here instead of at class instantiation time
        longPress = UILongPressGestureRecognizer(
            target: self, action: #selector(longPressInTable(recognizer:)))
        self.tableView.addGestureRecognizer(longPress)
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
        return sessions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            as? SessionTableViewCell else {
                return SessionTableViewCell()
        }

        cell.textLabel?.text = sessions[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedSession = sessions.remove(at: indexPath.row)
            delegate?.sessionTable(tableView, didRemove: deletedSession)
        }
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = Config.SessionTableViewCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sessionTable(tableView, didSelect: sessions[indexPath.row])
    }

    func newSession(barButton: UIBarButtonItem) {
        delegate?.sessionTable(tableView)
    }

    func longPressInTable(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }

        let point = recognizer.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }

        let sessionName = sessions[indexPath.row]

        let alert = UIAlertController(title: Config.SessionEditAlertTitle, message: nil, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: Config.SessionEditOkayTitle, style: .default, handler: { _ in
                guard let newName = alert.textFields?.first?.text else {
                    return
                }
                _ = DataManager.instance.editSessionName(oldSessionName: sessionName, newSessionName: newName)
                self.delegate?.sessionTable(self.tableView, didChange: sessionName, to: newName)
            }))
        alert.addAction(
            UIAlertAction(title: Config.SessionEditCancelTitle, style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.text = sessionName
        })
        self.present(alert, animated: true, completion: nil)
    }

}
