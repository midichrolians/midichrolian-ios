//
//  EditButton.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import Foundation

// Adopt this protocol to react when switching between different modes of the app.
protocol ModeSwitchDelegate: class {
    func enterEdit()
    func enterPlay()
}

// Default implementation of protocol, interested receivers can override specific methods.
extension ModeSwitchDelegate {
    func enterEdit() {
        return
    }
    func enterPlay() {
        return
    }
}
