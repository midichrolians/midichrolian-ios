//
//  TimelineDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Conform to this protocol to manage the actions and data for the timeline
protocol TimelineDelegate: class {
    // Gets informations about which frames have animation bit set
    var frame: [Bool] { get }

    // IndexPath of the currently selected frame
    var selectedFrame: IndexPath { get }

    // Called when a timeline frame is selected
    func timeline(selected: IndexPath)
}
