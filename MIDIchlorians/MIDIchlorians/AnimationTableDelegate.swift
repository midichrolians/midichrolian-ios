//
//  AnimationTableDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

// Adopt this protocol to react to selection of an animation in AnimationTableViewController.
protocol AnimationTableDelegate: class {
    func animationTable(_ tableView: UITableView, didSelect animation: String)
    func addAnimation(_ tableView: UITableView)
}

extension AnimationTableDelegate {
    func animationTable(_ tableView: UITableView, didSelect animation: String) {
    }

    func addAnimation(_ tableView: UITableView) {
    }
}
