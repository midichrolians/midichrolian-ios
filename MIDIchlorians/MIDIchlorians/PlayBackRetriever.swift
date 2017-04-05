//
//  PlayBacker.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 3/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

struct PlayBackRetriever {
    public static var instance = PlayBackRetriever(timeIndexArr: [(TimeInterval, (Int, IndexPath))]())
    private var timeIndexArr: [(TimeInterval, (Int, IndexPath))]
    init(timeIndexArr: [(TimeInterval, (Int, IndexPath))]) {
        self.timeIndexArr = timeIndexArr
    }

    //returns empty arr if there's nothing left
    //otherwise, returns one or more tuples
    mutating func getNextPads() -> [(TimeInterval, (Int, IndexPath))] {
        var nextPads = [(TimeInterval, (Int, IndexPath))]()
        guard let firstValue = removeNextTuple() else {
            return nextPads
        }
        nextPads.append(firstValue)
        repeat {
            guard let nextValue = timeIndexArr.first else {
                break
            }

            if firstValue.0 == nextValue.0 {
                timeIndexArr.removeFirst()
                nextPads.append(nextValue)
            } else {
                break
            }
        } while timeIndexArr.count > 0
        return nextPads
    }

    private mutating func removeNextTuple() -> (TimeInterval, (Int, IndexPath))? {
        guard !timeIndexArr.isEmpty else {
            return nil
        }
        return timeIndexArr.removeFirst()
    }
}
