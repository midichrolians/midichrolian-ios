//
//  SampleSettingMode.swift
//  MIDIchlorians
//
//  Created by anands on 10/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Samples can be in one of two modes, once-off or loop.
// Once off samples are played once when tapped, loop samples will be looped until user tops it.
enum SampleSettingMode: String {
    case once  = "Once-off"
    case loop = "Loop"

    static func allValues() -> [String] {
        return [once, loop]
            .map({ $0.rawValue })
    }
}
