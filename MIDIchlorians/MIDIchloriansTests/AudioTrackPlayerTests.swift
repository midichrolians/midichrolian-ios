//
//  AudioTrackPlayerTests.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class AudioTrackPlayerTests: XCTestCase {

    func testInitAudio() {
        let audioString = "AWOLNATION - Sail-1.wav"
        XCTAssertNotNil(AudioTrackPlayer.initAudioTrack(audioDir: audioString))
    }

    func testInitAudioFalse() {
        let audioString = ""
        XCTAssertNil(AudioTrackPlayer.initAudioTrack(audioDir: audioString))
    }

    func testPlaying() {
        let audioString = "AWOLNATION - Sail-1.wav"
        guard let audioPlayer = AudioTrackPlayer.initAudioTrack(audioDir: audioString) else {
            XCTFail()
            return
        }
        AudioTrackPlayer.playAudioTrack(audioPlayer: audioPlayer)
        XCTAssertTrue(AudioTrackPlayer.isPlaying(audioPlayer: audioPlayer))
    }

    func testPlayingFalse() {
        let audioString = "AWOLNATION - Sail-1.wav"
        guard let audioPlayer = AudioTrackPlayer.initAudioTrack(audioDir: audioString) else {
            XCTFail()
            return
        }
        XCTAssertFalse(AudioTrackPlayer.isPlaying(audioPlayer: audioPlayer))
    }

    func testStopPlaying() {
        let audioString = "AWOLNATION - Sail-1.wav"
        guard let audioPlayer = AudioTrackPlayer.initAudioTrack(audioDir: audioString) else {
            XCTFail()
            return
        }
        AudioTrackPlayer.playAudioTrack(audioPlayer: audioPlayer)
        XCTAssertTrue(AudioTrackPlayer.isPlaying(audioPlayer: audioPlayer))
        XCTAssertTrue(AudioTrackPlayer.stopAudioTrack(audioPlayer: audioPlayer))
        XCTAssertFalse(AudioTrackPlayer.isPlaying(audioPlayer: audioPlayer))
    }
}
