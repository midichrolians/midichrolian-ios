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
    var dataManager = DataManager()

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        dataManager = DataManager()
    }

    func testSaveSession() {
        let session = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1")
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: Config.animationTypeSparkName, indexPath: IndexPath(row: 0, section: 0))
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence!)
        XCTAssertTrue(session.equals(dataManager.saveSession("test", session)!))
        XCTAssertTrue(session.equals(dataManager.loadSession("test")!))
    }

    func testSaveSessionOverrwrite() {
        let session = Session(bpm: 120)
        XCTAssertTrue(session.equals(dataManager.saveSession("test", session)!))
        let newSession = Session(bpm: 140)
        let newSession1 = dataManager.saveSession("test", newSession)!
        XCTAssertTrue(newSession.equals(newSession1))
        XCTAssertTrue(newSession.equals(dataManager.loadSession("test")!))

        newSession1.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-2")
        XCTAssertTrue(newSession1.equals(dataManager.saveSession("test", newSession1)!))

    }

    func testRemoveSession() {
        let session = Session(bpm: 120)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1")
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: Config.animationTypeSparkName, indexPath: IndexPath(row: 0, section: 0))
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
    }

    func testLoadAllSessionNames() {
        let session = Session(bpm: 120)
        let sessionNameArray = ["test1", "test2", "test3"]
        for sessionName in sessionNameArray {
            _ = dataManager.saveSession(sessionName, session)
        }
        XCTAssertEqual(dataManager.loadAllSessionNames().sorted(), sessionNameArray)
    }

    func testSaveAnimation() {
        let animationType = "Spread"
        XCTAssertTrue(dataManager.saveAnimation(animationType))
        XCTAssertEqual(dataManager.loadAllAnimationTypes(), [animationType])
    }

    func testSaveAnimationOverwrite() {
        let animationType = "Spread"
        XCTAssertTrue(dataManager.saveAnimation(animationType))
        XCTAssertTrue(dataManager.saveAnimation(animationType))
        XCTAssertEqual(dataManager.loadAllAnimationTypes(), [animationType])
    }

    func testRemoveAnimation() {
        let animationType = "Spread"
        _ = dataManager.saveAnimation(animationType)
        XCTAssertTrue(dataManager.removeAnimation(animationType))
        XCTAssertEqual([], dataManager.loadAllAnimationTypes())
    }

    func testRemoveNonExistingAnimation() {
        let animationType = "Spread"
        _ = dataManager.saveAnimation(animationType)
        XCTAssertTrue(dataManager.removeAnimation(animationType))
        XCTAssertFalse(dataManager.removeAnimation(animationType))
    }

    func testLoadAllAnimations() {
        let animationTypes = ["Rainbow", "Spark", "Spread"]
        for animation in animationTypes {
            _ = dataManager.saveAnimation(animation)
        }
        XCTAssertEqual(dataManager.loadAllAnimationTypes().sorted(), animationTypes)

    }

    func testSaveAudio() {
        let audio = "AWOLNATION - Sail-1"
        XCTAssertTrue(dataManager.saveAudio(audio))
        XCTAssertEqual(dataManager.loadAllAudioStrings(), [audio])
    }

    func testSaveAudioOverwrite() {
        let audio = "AWOLNATION - Sail-1"
        XCTAssertTrue(dataManager.saveAudio(audio))
        XCTAssertTrue(dataManager.saveAudio(audio))
        XCTAssertEqual(dataManager.loadAllAudioStrings(), [audio])
    }

    func testRemoveAudio() {
        let audio = "AWOLNATION - Sail-1"
        _ = dataManager.saveAudio(audio)
        XCTAssertTrue(dataManager.removeAudio(audio))
        XCTAssertEqual([], dataManager.loadAllAudioStrings())

    }

    func testRemoveNonExistingAudio() {
        let audio = "AWOLNATION - Sail-1"
        _ = dataManager.saveAudio(audio)
        XCTAssertTrue(dataManager.removeAudio(audio))
        XCTAssertFalse(dataManager.removeAudio(audio))
    }

    func testLoadAllAudioStrings() {
        let audios = ["AWOLNATION - Sail-1", "AWOLNATION - Sail-2", "AWOLNATION - Sail-3"]
        for audio in audios {
            _ = dataManager.saveAudio(audio)
        }
        XCTAssertEqual(dataManager.loadAllAudioStrings().sorted(), audios)
    }

}
