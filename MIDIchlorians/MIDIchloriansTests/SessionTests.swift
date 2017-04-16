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

    func testInit() {
        let session = Session(bpm: 120)
        let testPad = Pad()
        XCTAssertEqual(120, session.getSessionBPM())
        for pad in session.getPadList() {
            XCTAssertEqual(testPad, pad)
        }

    }

    func testInitFromSession() {
        let session = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1.wav")
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence!)
        let newSession = Session(session: session)
        XCTAssertEqual(newSession, session)

    }

    func testSetSessionName() {
        let session = Session(bpm: 120)
        session.setSessionName(sessionName: "test")
        XCTAssertEqual(session.getSessionName()!, "test")

        session.setSessionName(sessionName: "test")
        XCTAssertEqual(session.getSessionName()!, "test")

        session.setSessionName(sessionName: "test1")
        XCTAssertEqual(session.getSessionName()!, "test1")

    }

    func testGetSessionName() {
        let session = Session(bpm: 120)
        XCTAssertNil(session.getSessionName())
        session.setSessionName(sessionName: "test")
        XCTAssertEqual(session.getSessionName()!, "test")

        session.setSessionName(sessionName: "test1")
        XCTAssertEqual(session.getSessionName()!, "test1")

    }

    func testAddBPMToPad() {
        let session = Session(bpm: 120)
        session.addBPMToPad(page: 0, row: 0, col: 0, bpm: 140)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertEqual(pad.getBPM()!, 140)

    }

    func testAddAudio() {
        let session = Session(bpm: 120)
        let audioString = "AWOLNATION - Sail-1.wav"
        session.addAudio(page: 0, row: 0, col: 0, audioFile: audioString)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertEqual(pad.getAudioFile()!, audioString)
    }

    func testClearAudio() {
        let session = Session(bpm: 120)
        let audioString = "AWOLNATION - Sail-1.wav"
        session.addAudio(page: 0, row: 0, col: 0, audioFile: audioString)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertEqual(pad.getAudioFile()!, audioString)
        session.clearAudio(page: 0, row: 0, col: 0)
        XCTAssertNil(pad.getAudioFile())
    }

    func testClearBPMAtPad() {
        let session = Session(bpm: 120)
        session.addBPMToPad(page: 0, row: 0, col: 0, bpm: 140)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertEqual(pad.getBPM()!, 140)
        session.clearBPMAtPad(page: 0, row: 0, col: 0)
        XCTAssertNil(pad.getBPM())
    }

    func testAddAnimation() {
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!
        let session = Session(bpm: 120)
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertEqual(pad.getAnimation()!.getJSON()!, animationSequence.getJSON()!)

    }

    func testClearAnimation() {
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!
        let session = Session(bpm: 120)
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertEqual(pad.getAnimation()!.getJSON()!, animationSequence.getJSON()!)
        session.clearAnimation(page: 0, row: 0, col: 0)
        XCTAssertNil(pad.getAnimation())

    }

    func testSetSessionBPM() {
        let session = Session(bpm: 120)
        session.setSessionBPM(bpm: 120)
        XCTAssertEqual(session.getSessionBPM(), 120)
        session.setSessionBPM(bpm: 140)
        XCTAssertEqual(session.getSessionBPM(), 140)
    }

    func testGetSessionBPM() {
        let session = Session(bpm: 120)
        XCTAssertEqual(session.getSessionBPM(), 120)
        session.setSessionBPM(bpm: 140)
        XCTAssertEqual(session.getSessionBPM(), 140)

    }

    func testGetPad() {
        let session = Session(bpm: 120)
        let pad = Pad()
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1.wav")
        session.addBPMToPad(page: 0, row: 0, col: 0, bpm: 140)

        pad.addAudio(audioFile: "AWOLNATION - Sail-1.wav")
        pad.addAnimation(animation: animationSequence)
        pad.setBPM(bpm: 140)

        XCTAssertEqual(session.getPad(page: 0, row: 0, col: 0)!, pad)
    }

    func testEquality() {
        let session = Session(bpm: 120)
        let otherSession = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1.wav")
        otherSession.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1.wav")
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence)
        otherSession.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence)
        XCTAssertEqual(otherSession, session)
        otherSession.setSessionName(sessionName: "A")
        XCTAssertNotEqual(otherSession, session)
    }

    func testJSONSerialisation() {
        let session = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1.wav")
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "Spark", indexPath: IndexPath(row: 0, section: 0))!
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence)
        let json = session.toJSON()!
        let newSession = Session(json: json)
        XCTAssertEqual(session, newSession)
    }
}
