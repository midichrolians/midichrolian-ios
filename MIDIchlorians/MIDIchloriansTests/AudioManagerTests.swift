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

    func testInitAudioDoesntExist() {
        let audioStringDoesntExist = ""
        let testInit = AudioManager.instance.initAudio(audioDir: audioStringDoesntExist)
        XCTAssertFalse(testInit)
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
        XCTAssertTrue(AudioManager.instance.isTrackPlaying(audioDir: audioString))
    }

    func testIsPlayingFalse() {
        let audioString = "doesntexist"
        XCTAssertFalse(AudioManager.instance.isTrackPlaying(audioDir: audioString))
    }

    func testLoop() {
        let audioString = "AWOLNATION - Sail-1.wav"
        //loop starts
        _ = AudioManager.instance.play(audioDir: audioString, bpm: 100)
        XCTAssertTrue(AudioManager.instance.isTrackPlaying(audioDir: audioString))
        _ = AudioManager.instance.play(audioDir: audioString)
        //loop stops
        XCTAssertTrue(AudioManager.instance.isTrackPlaying(audioDir: audioString))
    }
}
