//
//  SampleTableDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

// Adopt this protocol to react to selection of a sample in SampleTableViewController.
protocol SampleTableDelegate: class {
    // A sample is selected
    func sampleTable(_: UITableView, didSelect sample: String)
}
