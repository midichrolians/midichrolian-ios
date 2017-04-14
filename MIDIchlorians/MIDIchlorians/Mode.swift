//
//  Mode.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 12/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// The different modes the app can be in
enum Mode {
    // Playing/Performance mode, all editing panels should be hidden
    case playing
    // Editing mode, users can select pads to assign samples and animations
    case editing
    // Animation designing mode, users can use the timeline and palette to create custom animations
    case design
}
