//
//  SessionTableDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 12/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

// Adopt this protocol to react to selection of a session in SessionTableViewController
protocol SessionTableDelegate: class {
    // A session in the table is selected, we probably want to load it
    func sessionTable(_: UITableView, didSelect sessionName: String)
    // The add button in the session table is selected
    func sessionTable(_: UITableView)
    // A session is deleted
    func sessionTable(_: UITableView, didRemove sessionName: String)
}
