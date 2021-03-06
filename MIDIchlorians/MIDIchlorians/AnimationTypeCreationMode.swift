//
//  AnimationTypeCreationMode.swift
//  MIDIchlorians
//
//  Created by anands on 28/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

enum AnimationTypeCreationMode: String {
    case relative
    case absolute

    static func allValues() -> [String] {
        return [relative, absolute]
            .map({ $0.rawValue })
    }
}
