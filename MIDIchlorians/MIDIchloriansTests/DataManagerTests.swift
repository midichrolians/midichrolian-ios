//
//  DataManagerTests.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
import RealmSwift
@testable import MIDIchlorians

class DataManagerTests: XCTestCase {
    let dataManager = DataManager.instance

    override func setUp() {
        super.setUp()
    }

    func testSaveSession() {
        let session = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1")
        let animationSequence = AnimationTypes.getAnimationSequenceForAnimationType(animationTypeName: Config.animationTypeSparkName,
                                                                indexPath: IndexPath(row: 0, section: 0))
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence!)
        XCTAssertTrue(dataManager.saveSession("test", session))
        XCTAssertTrue(session.equals(dataManager.loadSession("test")!))
    }

    func testSaveSessionOverrwrite() {
        let session = Session(bpm: 120)
        XCTAssertTrue(dataManager.saveSession("test", session))
        let newSession = Session(bpm: 140)
        XCTAssertTrue(dataManager.saveSession("test", newSession))
        XCTAssertTrue(newSession.equals(dataManager.loadSession("test")!))
    }
    
    func testRemoveSession() {
        let session = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1")
        let animationSequence = AnimationTypes.getAnimationSequenceForAnimationType(animationTypeName: Config.animationTypeSparkName, indexPath: IndexPath(row: 0, section: 0))
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence!)
        _ = dataManager.saveSession("test", session)
        XCTAssertTrue(dataManager.removeSession("test"))
        XCTAssertNil(dataManager.loadSession("test"))
    }
    
    func testRemoveNonExistingSession() {
        let session = Session(bpm: 120)
        _ = dataManager.saveSession("test", session)
        XCTAssertTrue(dataManager.removeSession("test"))
        XCTAssertFalse(dataManager.removeSession("test"))
    }

    func testLoadSession() {
        let session = Session(bpm: 120)
        _ = dataManager.saveSession("test", session)
        let x = dataManager.loadSession("test")!
        XCTAssertTrue(session.equals(x))
        x.addAudio(page: 0, row: 0, col: 0, audioFile: "AAA")
    }

    func testLoadAllSessionNames() {
        let session = Session(bpm: 120)
        _ = dataManager.saveSession("test1", session)
        _ = dataManager.saveSession("test2", session)
        _ = dataManager.saveSession("test3", session)
        XCTAssertEqual(dataManager.loadAllSessionNames().sorted(), ["test1", "test2", "test3"])
    }

    func testSaveAnimation() {

    }

    func testSaveAnimationOverrwite() {

    }

    func testRemoveAnimation() {

    }

    func testLoadAllAnimations() {

    }

    func testSaveAudio() {

    }

    func testRemoveAudio() {

    }

    func testLoadAllAudioStrings() {

    }

}
