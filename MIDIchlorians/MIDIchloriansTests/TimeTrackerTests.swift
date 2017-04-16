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
        XCTAssertEqual(timePathDict, [(TimeInterval, (Int, IndexPath))]())
    }
    
    func testStopRecord() {
        RecorderManager.instance.startRecord()
        XCTAssertTrue(RecorderManager.instance.isRecording)
        RecorderManager.instance.stopRecord()
        XCTAssertFalse(RecorderManager.instance.isRecording)
    }
    
    func testStartPlay() {
        RecorderManager.instance.startPlay()
        XCTAssertTrue(RecorderManager.instance.isPlaying)
    }
    
    func testStopPlay() {
        RecorderManager.instance.startPlay()
        XCTAssertTrue(RecorderManager.instance.isPlaying)
        RecorderManager.instance.stopPlay()
        XCTAssertFalse(RecorderManager.instance.isPlaying)
    }
    
}
