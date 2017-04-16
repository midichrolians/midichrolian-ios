//
//  TimeTrackerTests.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class TimeTrackerTests: XCTestCase {

    func testTimeTrackerInit() {
        let timeTracker = TimeTracker()
        let timePathDict = timeTracker.timePathDict
        XCTAssertEqual(timePathDict.count, 0)
    }

    func testTimeTracker() {
        var timeTracker = TimeTracker()
        let indexPath = IndexPath(item: 0, section: 0)
        timeTracker.setTimePadPair(pageNum: 0, forIndex: indexPath)
        let timePathArr = timeTracker.timePathDict
        let timeInt: TimeInterval = 0
        XCTAssertEqual(timePathArr[0].0, timeInt)
        XCTAssertEqual(timePathArr[0].1.0, 0)
        XCTAssertEqual(timePathArr[0].1.1, IndexPath(item: 0, section: 0))
    }
}
