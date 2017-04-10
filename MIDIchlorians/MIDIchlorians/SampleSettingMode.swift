//
//  SampleSettingMode.swift
//  MIDIchlorians
//
//  Created by anands on 10/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

enum SampleSettingMode: String {
    case once  = "Once-off"
    case loop = "Loop"

    static func allValues() -> [String] {
        return [once, loop]
            .map({ $0.rawValue })
    }
}
