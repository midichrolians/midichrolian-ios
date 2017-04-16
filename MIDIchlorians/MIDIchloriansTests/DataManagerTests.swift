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

        newSession1.setSessionName(sessionName: "AD")
        XCTAssertTrue(newSession1.equals(dataManager.saveSession(newSession1.getSessionName()!, newSession1)!))

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

    func testLoadLastSession() {
        let session = Session(bpm: 120)
        XCTAssertNil(dataManager.loadLastSession())
        let sessionNameArray = ["test1", "test2", "test3"]
        for sessionName in sessionNameArray {
            _ = dataManager.saveSession(sessionName, session)
        }
        XCTAssertEqual("test3", dataManager.loadLastSession()!.getSessionName()!)
        let session1 = Session(bpm: 140)
        _ = dataManager.saveSession("test4", session1)
        XCTAssertTrue(session1.equals(dataManager.loadLastSession()!))
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

    func testEditSessionName() {
        let session = Session(bpm: 120)
        let session1 = Session(bpm: 120)
        _ = dataManager.saveSession("test", session)
        XCTAssertFalse(dataManager.editSessionName(oldSessionName: "test1", newSessionName: "test12"))
        XCTAssertTrue(dataManager.editSessionName(oldSessionName: "test", newSessionName: "test12"))
        XCTAssertTrue(session1.equals(dataManager.loadSession("test12")!))
    }

    func testGetSamplesForGroup() {
        XCTAssertEqual([], dataManager.getSamplesForGroup(group: "sail"))
        var audios = ["AWOLNATION - Sail-1", "AWOLNATION - Sail-2", "AWOLNATION - Sail-3"]
        audios.forEach({ sample in
            _ = dataManager.saveAudio(sample)
            _ = dataManager.addSampleToGroup(group: "sail", sample: sample)
        })
        XCTAssertEqual(audios, dataManager.getSamplesForGroup(group: "sail").sorted())
        _ = dataManager.addSampleToGroup(group: "sail1", sample: "AWOLNATION - Sail-4")
        _ = dataManager.saveAudio("AWOLNATION - Sail-5")
        _ = dataManager.addSampleToGroup(group: "sail", sample: "AWOLNATION - Sail-5")
        _ = dataManager.addSampleToGroup(group: "sail", sample: "AWOLNATION - Sail-3")
        audios.append("AWOLNATION - Sail-5")
        XCTAssertEqual(audios, dataManager.getSamplesForGroup(group: "sail").sorted())

    }

    func testAddSampleToGroup() {
        var audios = ["AWOLNATION - Sail-1", "AWOLNATION - Sail-2", "AWOLNATION - Sail-3"]
        audios.forEach({ sample in
            _ = dataManager.saveAudio(sample)
            XCTAssertTrue(dataManager.addSampleToGroup(group: "sail", sample: sample))
        })
        XCTAssertEqual(audios, dataManager.getSamplesForGroup(group: "sail").sorted())

        //Test adding sample that does not exist
        XCTAssertFalse(dataManager.addSampleToGroup(group: "sail", sample: "AWOLNATION - Sail-5"))
        XCTAssertEqual(audios, dataManager.getSamplesForGroup(group: "sail").sorted())

        //Test adding sample to same group
        _ = dataManager.saveAudio("AWOLNATION - Sail-5")
        audios.append("AWOLNATION - Sail-5")
        XCTAssertTrue(dataManager.addSampleToGroup(group: "sail", sample: "AWOLNATION - Sail-5"))
        XCTAssertEqual(audios, dataManager.getSamplesForGroup(group: "sail").sorted())

        //Test adding sample to different group
        _ = dataManager.saveAudio("AWOLNATION - Sail-4")
        XCTAssertTrue(dataManager.addSampleToGroup(group: "sail1", sample: "AWOLNATION - Sail-4"))
        XCTAssertEqual(["AWOLNATION - Sail-4"], dataManager.getSamplesForGroup(group: "sail1"))

        //Test changing group
        XCTAssertEqual(audios, dataManager.getSamplesForGroup(group: "sail").sorted())
        XCTAssertTrue(dataManager.addSampleToGroup(group: "sail1", sample: "AWOLNATION - Sail-5"))
        let removedSample = audios.removeLast()
        XCTAssertEqual(audios, dataManager.getSamplesForGroup(group: "sail").sorted())
        XCTAssertEqual(["AWOLNATION - Sail-4", removedSample],
                       dataManager.getSamplesForGroup(group: "sail1").sorted())

    }

    func testGetAllGroups() {
        let audios = ["AWOLNATION - Sail-1", "AWOLNATION - Sail-2", "AWOLNATION - Sail-3"]
        audios.forEach({ sample in
            _ = dataManager.saveAudio(sample)
            XCTAssertTrue(dataManager.addSampleToGroup(group: sample, sample: sample))
        })
        XCTAssertEqual(audios, dataManager.getAllGroups().sorted())
    }

}
