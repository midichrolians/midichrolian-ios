//
//  BeatFrequency.swift
//  MIDIchlorians
//
//  Created by anands on 3/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

enum BeatFrequency: Int {
    case one = 1
    case two = 2
    case four = 4
    case eight = 8
    case sixteen = 16

    init(name: String) {
        guard let number = Int(name) else {
            self = BeatFrequency.one
            return
        }
        guard let beatFrequency = BeatFrequency(rawValue: number) else {
            self = BeatFrequency.one
            return
        }
        self = beatFrequency
    }

    static var max: Int {
        return BeatFrequency.sixteen.rawValue
    }

    func framesInABeat() -> Int {
        return BeatFrequency.max / rawValue
    }

    func getJSON() -> String {
        return String(rawValue)
    }
}
