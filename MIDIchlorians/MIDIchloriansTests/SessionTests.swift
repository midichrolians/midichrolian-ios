//
//  SessionTests.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class SessionTests: XCTestCase {

    func testGetSessionName() {

    }

    func testAddAudio() {
        let session = Session(bpm: 120)
        let audioString = "AWOLNATION - Sail-1"
        session.addAudio(page: 0, row: 0, col: 0, audioFile: audioString)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertEqual(pad.getAudioFile()!, audioString)
    }

    func testClearAudio() {

    }

    func testClearAnimation() {

    }

    func testSetBPM() {

    }

    func testPrepareForSave() {

    }

    func testLoad() {
    }

    func testGetPad() {

    }

}
