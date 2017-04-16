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

    func testInit() {
        let pad = Pad()
        pad.addAudio(audioFile: "AWOLNATION - Sail-1.wav")
        pad.setBPM(bpm: 120)
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))
        pad.addAnimation(animation: animationSequence!)
        let newPad = Pad(pad)
        XCTAssertEqual(pad, newPad)
    }

    func testJSONSerialisation() {
        let pad = Pad()
        pad.addAudio(audioFile: "AWOLNATION - Sail-1.wav")
        pad.setBPM(bpm: 120)
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))
        pad.addAnimation(animation: animationSequence!)
        let json = pad.toJSON()
        let newPad = Pad(json: json!)
        XCTAssertEqual(pad, newPad)
    }

    func testAddAudio() {
        let audioString = "AWOLNATION - Sail-1.wav"
        let pad = Pad()
        XCTAssertNil(pad.getAudioFile())

        pad.addAudio(audioFile: audioString)
        XCTAssertEqual(pad.getAudioFile()!, audioString)

        pad.addAudio(audioFile: audioString)
        XCTAssertEqual(pad.getAudioFile()!, audioString)

        pad.addAudio(audioFile: "AWOLNATION - Sail-2.wav")
        XCTAssertEqual(pad.getAudioFile()!, "AWOLNATION - Sail-2.wav")
    }

    func testAddAnimation() {

        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!

        let animationSequence2 = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Rainbow", indexPath: IndexPath(row: 0, section: 0))!

        let pad = Pad()
        XCTAssertNil(pad.getAnimation())

        pad.addAnimation(animation: animationSequence)
        XCTAssertEqual(pad.getAnimation()!.getJSON()!,
                       animationSequence.getJSON()!)

        pad.addAnimation(animation: animationSequence)
        XCTAssertEqual(pad.getAnimation()!.getJSON()!,
                       animationSequence.getJSON()!)

        pad.addAnimation(animation: animationSequence2)
        XCTAssertEqual(pad.getAnimation()!.getJSON()!,
                       animationSequence2.getJSON()!)

    }

    func testGetAnimation() {
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!
        let pad = Pad()
        pad.addAnimation(animation: animationSequence)
        XCTAssertEqual(pad.getAnimation()!.getJSON()!,
                       animationSequence.getJSON()!)
        pad.clearAnimation()
        XCTAssertNil(pad.getAnimation())

    }

    func testGetAudioFile() {
        let audioString = "AWOLNATION - Sail-1.wav"
        let pad = Pad()
        pad.addAudio(audioFile: audioString)
        XCTAssertEqual(pad.getAudioFile()!, audioString)
        pad.clearAudio()
        XCTAssertNil(pad.getAudioFile())
    }

    func testClearAudio() {
        let audioString = "AWOLNATION - Sail-1.wav"
        let pad = Pad()
        pad.addAudio(audioFile: audioString)
        XCTAssertEqual(pad.getAudioFile()!, audioString)
        pad.clearAudio()
        XCTAssertNil(pad.getAudioFile())

    }

    func testClearAnimation() {
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!
        let pad = Pad()
        pad.addAnimation(animation: animationSequence)
        XCTAssertEqual(pad.getAnimation()!.getJSON()!,
                       animationSequence.getJSON()!)
        pad.clearAnimation()
        XCTAssertNil(pad.getAnimation())
    }

    func testSetBPM() {
        let pad = Pad()
        pad.setBPM(bpm: 120)
        XCTAssertEqual(120, pad.getBPM()!)

        pad.setBPM(bpm: 120)
        XCTAssertEqual(120, pad.getBPM()!)

        pad.setBPM(bpm: 140)
        XCTAssertEqual(140, pad.getBPM()!)
    }

    func testGetBPM() {
        let pad = Pad()
        XCTAssertNil(pad.getBPM())
        pad.setBPM(bpm: 120)
        XCTAssertEqual(120, pad.getBPM()!)

        pad.setBPM(bpm: 140)
        XCTAssertEqual(140, pad.getBPM()!)
    }

    func testClearBPM() {
        let pad = Pad()
        pad.setBPM(bpm: 120)
        XCTAssertEqual(120, pad.getBPM()!)
        pad.clearBPM()
        XCTAssertNil(pad.getBPM())
    }

    func testEquality() {
        let audioString = "AWOLNATION - Sail-1.wav"
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!

        let pad = Pad()
        let pad1 = Pad()
        XCTAssertEqual(pad, pad1)

        pad.setBPM(bpm: 120)
        pad1.setBPM(bpm: 120)
        XCTAssertEqual(pad, pad1)

        pad.addAudio(audioFile: audioString)
        pad1.addAudio(audioFile: audioString)
        XCTAssertEqual(pad, pad1)

        pad.addAnimation(animation: animationSequence)
        pad1.addAnimation(animation: animationSequence)
        XCTAssertEqual(pad, pad1)

        pad1.clearBPM()
        XCTAssertNotEqual(pad, pad1)

    }
}
