//
//  TimeTracker.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 1/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

struct TimeTracker {
    private var timeIndexDict: [TimeInterval: IndexPath]
    private let start: Date
    //the 'fps' at which we will play the recording
    private let PLAYBACKACCURACY:TimeInterval = 1/60

    //save the start time to compare to in setTimePadPair
    init () {
        start = Date()
        timeIndexDict = [TimeInterval: IndexPath]()
    }

    //record pad at time since started
    mutating func setTimePadPair(forIndex indexPath: IndexPath) {
        let timeInterval = start.timeIntervalSinceNow
        //to make sure that the playback presses two buttons at the same time instead of slightly off synch
        timeInterval -= timeInterval%PLAYBACKACCURACY
        timeIndexDict[timeInterval] = indexPath
    }

    //to save or to replay
    var timePathDict: [TimeInterval: IndexPath] {
        return timeIndexDict
    }
}
