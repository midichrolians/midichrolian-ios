//
//  PlayBackRetrieverTests.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class PlayBackRetrieverTests: XCTestCase {

    func testPlayBackRetrieverInit() {
        var playBackR = PlayBackRetriever(timeIndexArr: [(TimeInterval, (Int, IndexPath))]())
        XCTAssertEqual(playBackR.getNextPads().count, 0)
    }
}
