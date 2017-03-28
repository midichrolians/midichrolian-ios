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
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    func testSaveEmptySession() {
        let session = Session(bpm: 120)
        XCTAssertTrue(dataManager.saveSession("test", session))
        XCTAssertEqual(session, dataManager.loadSession("test")!)
    }

    func testSaveSessionOverrwrite() {
        let session = Session(bpm: 120)
        XCTAssertTrue(dataManager.saveSession("test", session))
        let newSession = Session(bpm: 140)
        XCTAssertTrue(dataManager.saveSession("test", newSession))
        XCTAssertEqual(newSession, dataManager.loadSession("test")!)
    }

    func testSaveSessionWithAudio() {
        let session = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1")
        XCTAssertTrue(dataManager.saveSession("test", session))
        XCTAssertEqual(session, dataManager.loadSession("test")!)

    }

    func testSaveSessionWithAnimation() {
        let session = Session(bpm: 120)
        let animationSequence = AnimationTypes.getAnimationSequenceForAnimationType(animationTypeName: Config.animationTypeSparkName,
                                                 indexPath: IndexPath(row: 0, section: 0))
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence!)
        XCTAssertTrue(dataManager.saveSession("test", session))
        XCTAssertEqual(session, dataManager.loadSession("test")!)
    }

    func testLoadSession() {
        XCTAssertNil(dataManager.loadSession("test1"))
        let session = Session(bpm: 120)
        XCTAssertTrue(dataManager.saveSession("test1", session))
        XCTAssertEqual(session, dataManager.loadSession("test1")!)

    }

    func testLoadAllSessionNames() {

    }

    func testSaveAnimation() {

    }

    func testLoadAllAnimations() {

    }

    func testSaveAudio() {

    }

    func testLoadAllAudioStrings() {
    }

}
