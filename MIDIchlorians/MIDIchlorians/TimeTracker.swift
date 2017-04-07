//
//  TimeTracker.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 1/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

struct TimeTracker {
    private var timeIndexArr: [(TimeInterval, (Int, IndexPath))]
    private let start: Date
    //the 'fps' at which we will play the recording
    private let PLAYBACKACCURACY: TimeInterval = 1/60
    //save the start time to compare to in setTimePadPair
    init () {
        start = Date()
        timeIndexArr = [(TimeInterval, (Int, IndexPath))]()
    }

    //record pad at time since started
    mutating func setTimePadPair(pageNum page: Int, forIndex indexPath: IndexPath) {
        var timeInterval = start.timeIntervalSinceNow
        //to make sure that the playback presses two buttons at the same time instead of slightly off synch
        timeInterval = timeInterval.truncatingRemainder(dividingBy: PLAYBACKACCURACY) - timeInterval
        timeIndexArr.append((timeInterval, (page, indexPath)))
    }

    //to save or to replay
    var timePathDict: [(TimeInterval, (Int, IndexPath))] {
        return timeIndexArr
    }

}
