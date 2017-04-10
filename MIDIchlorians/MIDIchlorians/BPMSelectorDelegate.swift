//
//  BPMSelectorDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 10/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Conform to this delegate to be notified when the bpm selector is changed
protocol BPMSelectorDelegate: class {
    // BPM was selected
    func bpm(selected bpm: Int)
}
