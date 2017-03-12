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
    func sessionTable(_: UITableView, didSelect session: String)
}
