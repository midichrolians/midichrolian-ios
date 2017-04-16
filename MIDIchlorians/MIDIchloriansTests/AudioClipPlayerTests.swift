//
//  AudioClipPlayerTests.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class AudioClipPlayerTests: XCTestCase {

    func testInitAudio() {
        let audioString = "AWOLNATION - Sail-1.wav"
        XCTAssertNotNil(AudioClipPlayer.initAudioClip(audioDir: audioString))
    }

    func testInitAudioFalse() {
        let audioString = ""
        XCTAssertEqual((AudioClipPlayer.initAudioClip(audioDir: audioString)), 0)
    }

}
