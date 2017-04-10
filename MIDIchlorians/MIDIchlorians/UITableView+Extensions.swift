//
//  UITableView+Extensions.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 9/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func deselectAll(animated: Bool = true) {
        self.indexPathsForSelectedRows.flatMap {
            $0.forEach { self.deselectRow(at: $0, animated: animated) }
        }
    }
}
