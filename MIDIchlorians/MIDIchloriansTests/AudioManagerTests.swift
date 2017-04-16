//
//  AudioManagerTests.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class AudioManagerTests: XCTestCase {

    func testInitAudio() {
        let audioString = "AWOLNATION - Sail-1.wav"
        let testInit = AudioManager.instance.initAudio(audioDir: audioString)
        XCTAssertTrue(testInit)
    }

    //TODO: shouldn't be true
    func testInitAudioDoesntExist() {
        let audioStringDoesntExist = ""
        let testInit = AudioManager.instance.initAudio(audioDir: audioStringDoesntExist)
        XCTAssertTrue(testInit)
    }

    func testAudioPlay() {
        let audioString = "AWOLNATION - Sail-1.wav"
        _ = AudioManager.instance.initAudio(audioDir: audioString)
        let testPlay = AudioManager.instance.play(audioDir: audioString)
        XCTAssertTrue(testPlay)
    }

    func testAudioPlayDoesntExist() {
        let audioStringDoesntExist = ""
        let testPlay = AudioManager.instance.play(audioDir: audioStringDoesntExist)
        XCTAssertFalse(testPlay)
    }

    func testGetDuration() {
        let audioString = "AWOLNATION - Sail-1.wav"
        let duration = AudioManager.instance.getDuration(for: audioString)
        XCTAssertEqual(duration, "0 min 1 seconds")
    }

    func testGetDurationDoesntExist() {
        let audioString = ""
        let duration = AudioManager.instance.getDuration(for: audioString)
        XCTAssertEqual(duration, "0 min 0 seconds")
    }

    func testIsPlaying() {
        let audioString = "AWOLNATION - Sail-1.wav"
        _ = AudioManager.instance.play(audioDir: audioString)
        let isPlaying = AudioManager.instance.isTrackPlaying(audioDir: audioString)
        XCTAssertTrue(isPlaying)
    }
}
