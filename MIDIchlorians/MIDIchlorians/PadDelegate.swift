//
//  PadDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 27/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Conform to this protocol to be informed when a pad is tapped
protocol PadDelegate: class {
    // Called everytime a pad is tapped
    func padTapped(indexPath: IndexPath)

    // When a pad is tapped for the first time to be selected
    func pad(selected: Pad)

    // When a pad is tapped for the second time to be played
    func pad(played: Pad)

    // When an animation is added in design mode)
    func pad(animationUpdated animation: AnimationSequence)
}

// Default implementation that does nothing
extension PadDelegate {
    func padTapped(indexPath: IndexPath) {
    }

    func pad(selected: Pad) {
    }

    func pad(played: Pad) {
    }

    func pad(animationUpdated: AnimationSequence) {
    }
}
