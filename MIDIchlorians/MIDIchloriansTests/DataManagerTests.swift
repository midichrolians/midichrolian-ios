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
        session.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-1.wav")
        let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: Config.animationTypeSparkName, indexPath: IndexPath(row: 0, section: 0))
        session.addAnimation(page: 0, row: 0, col: 0, animation: animationSequence!)
        XCTAssertEqual(session, dataManager.saveSession("test", session)!)
        XCTAssertEqual(session, dataManager.loadSession("test")!)
    }

    func testSaveSessionOverrwrite() {
        let session = Session(bpm: 120)
        XCTAssertEqual(session, dataManager.saveSession("test", session)!)
        let newSession = Session(bpm: 140)
        let newSession1 = dataManager.saveSession("test", newSession)!
        XCTAssertEqual(newSession, newSession1)
        XCTAssertEqual(newSession, dataManager.loadSession("test")!)

        newSession1.addAudio(page: 0, row: 0, col: 0, audioFile: "AWOLNATION - Sail-2.wav")
        XCTAssertEqual(newSession1, dataManager.saveSession("test", newSession1)!)

        newSession1.setSessionName(sessionName: "AD")
        XCTAssertEqual(newSession1, dataManager.saveSession(newSession1.getSessionName()!, newSession1)!)

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
        XCTAssertTrue(dataManager.removeSession("test"))
    }

    func testLoadSession() {
        let session = Session(bpm: 120)
        _ = dataManager.saveSession("test", session)
        let x = dataManager.loadSession("test")!
        XCTAssertEqual(session, x)
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
        XCTAssertEqual(session1, dataManager.loadLastSession()!)
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
        XCTAssertTrue(dataManager.removeAnimation(animationType))
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
        XCTAssertTrue(dataManager.removeAudio(audio))
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
        XCTAssertEqual(session1, dataManager.loadSession("test12")!)
    }

    func testGetAudiosForGroup() {
        XCTAssertEqual([], dataManager.getAudiosForGroup(group: "sail"))
        var audios = ["AWOLNATION - Sail-1.wav", "AWOLNATION - Sail-2.wav", "AWOLNATION - Sail-3.wav"]
        audios.forEach({ sample in
            _ = dataManager.saveAudio(sample)
            _ = dataManager.addAudioToGroup(group: "sail", audio: sample)
        })
        XCTAssertEqual(audios, dataManager.getAudiosForGroup(group: "sail").sorted())
        _ = dataManager.addAudioToGroup(group: "sail1", audio: "AWOLNATION - Sail-4.wav")
        _ = dataManager.saveAudio("AWOLNATION - Sail-5.wav")
        _ = dataManager.addAudioToGroup(group: "sail", audio: "AWOLNATION - Sail-5.wav")
        _ = dataManager.addAudioToGroup(group: "sail", audio: "AWOLNATION - Sail-3")
        audios.append("AWOLNATION - Sail-5.wav")
        XCTAssertEqual(audios, dataManager.getAudiosForGroup(group: "sail").sorted())

    }

    func testAddAudiosToGroup() {
        var audios = ["AWOLNATION - Sail-1.wav", "AWOLNATION - Sail-2.wav", "AWOLNATION - Sail-3.wav"]
        audios.forEach({ sample in
            _ = dataManager.saveAudio(sample)
            XCTAssertTrue(dataManager.addAudioToGroup(group: "sail", audio: sample))
        })
        XCTAssertEqual(audios, dataManager.getAudiosForGroup(group: "sail").sorted())

        //Test adding sample that does not exist
        XCTAssertFalse(dataManager.addAudioToGroup(group: "sail", audio: "AWOLNATION - Sail-5.wav"))
        XCTAssertEqual(audios, dataManager.getAudiosForGroup(group: "sail").sorted())

        //Test adding sample to same group
        _ = dataManager.saveAudio("AWOLNATION - Sail-5.wav")
        audios.append("AWOLNATION - Sail-5.wav")
        XCTAssertTrue(dataManager.addAudioToGroup(group: "sail", audio: "AWOLNATION - Sail-5.wav"))
        XCTAssertEqual(audios, dataManager.getAudiosForGroup(group: "sail").sorted())

        //Test adding sample to different group
        _ = dataManager.saveAudio("AWOLNATION - Sail-4.wav")
        XCTAssertTrue(dataManager.addAudioToGroup(group: "sail1", audio: "AWOLNATION - Sail-4.wav"))
        XCTAssertEqual(["AWOLNATION - Sail-4.wav"], dataManager.getAudiosForGroup(group: "sail1"))

        //Test changing group
        XCTAssertEqual(audios, dataManager.getAudiosForGroup(group: "sail").sorted())
        XCTAssertTrue(dataManager.addAudioToGroup(group: "sail1", audio: "AWOLNATION - Sail-5.wav"))
        let removedSample = audios.removeLast()
        XCTAssertEqual(audios, dataManager.getAudiosForGroup(group: "sail").sorted())
        XCTAssertEqual(["AWOLNATION - Sail-4.wav", removedSample],
                       dataManager.getAudiosForGroup(group: "sail1").sorted())

    }

    func testGetAllAudioGroups() {
        let audios = ["AWOLNATION - Sail-1.wav", "AWOLNATION - Sail-2.wav", "AWOLNATION - Sail-3.wav"]
        audios.forEach({ sample in
            _ = dataManager.saveAudio(sample)
            XCTAssertTrue(dataManager.addAudioToGroup(group: sample, audio: sample))
        })
        XCTAssertEqual(audios, dataManager.getAllAudioGroups().sorted())
    }

    func testGetAudioGroup() {
        let session = Session(bpm: 120)
        let audioFile = "AWOLNATION - Sail-1.wav"
        _ = dataManager.saveAudio(audioFile)
        session.addAudio(page: 0, row: 0, col: 0, audioFile: audioFile)
        let pad = session.getPad(page: 0, row: 0, col: 0)!
        XCTAssertNil(dataManager.getAudioGroup(pad: pad))
        _ = dataManager.addAudioToGroup(group: "sail", audio: audioFile)
        XCTAssertEqual(dataManager.getAudioGroup(pad: pad)!, "sail")
        _ = dataManager.addAudioToGroup(group: "sail1", audio: audioFile)
        XCTAssertEqual(dataManager.getAudioGroup(pad: pad)!, "sail1")
    }

}
