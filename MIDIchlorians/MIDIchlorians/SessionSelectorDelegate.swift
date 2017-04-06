//
//  SessionSelectorDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 23/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

// Adopt this protocol to react when session selector is tapped
protocol SessionSelectorDelegate: class {
    func sessionSelector(sender: UIButton)
}
