//
//  PadTests.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class PadTests: XCTestCase {

    func testAddAudio() {
        let audioString = "AWOLNATION - Sail-1"
        let pad = Pad()
        XCTAssertNil(pad.getAudioFile())
        pad.addAudio(audioFile: audioString)
        XCTAssertEqual(pad.getAudioFile()!, audioString)
    }

    func testAddAnimation() {

    }

    func testGetAudio() {
        let audioString = "AWOLNATION - Sail-1"
        let pad = Pad()
        pad.addAudio(audioFile: audioString)
        XCTAssertEqual(pad.getAudioFile()!, audioString)
        pad.clearAudio()
        XCTAssertNil(pad.getAudioFile())

    }

    func testGetAnimation() {

    }

    func testClearAudio() {
        let audioString = "AWOLNATION - Sail-1"
        let pad = Pad()
        pad.addAudio(audioFile: audioString)
        XCTAssertEqual(pad.getAudioFile()!, audioString)
        pad.clearAudio()
        XCTAssertNil(pad.getAudioFile())

    }

    func testClearAnimation() {

    }
}
