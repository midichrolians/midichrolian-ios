//
//  SessionSaver.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 18/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

class DataManager {

    private let realm: Realm?
    static let instance = DataManager()
    private var sessionNames: Set<String>
    private var animationStrings: Set<String>
    private var audioStrings: Set<String>
    private var audioGroups: Set<String>
    private var lastSessionName: String?

    //TODO: REALM INIT CAN FAIL
    init() {
        // Not sure if this line should always be there
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        realm = try? Realm()
        lastSessionName = nil
        sessionNames = Set<String>()
        animationStrings = Set<String>()
        audioStrings = Set<String>()
        audioGroups = Set<String>()
        initialiseSessionNames()
        initialiseAnimations()
        initialiseAudios()
        initialiseAudioGroups()
    }

    private func initialiseSessionNames() {
        guard let sessionNames = realm?.objects(SessionName.self) else {
            return
        }
        for sessionName in sessionNames {
            if let sessionNameString = sessionName.getSessionName() {
                self.sessionNames.insert(sessionNameString)
                self.lastSessionName = sessionNameString
            }
        }
    }

    private func initialiseAnimations() {
        guard let animations = realm?.objects(Animation.self) else {
            return
        }
        for animation in animations {
            let animationString = animation.getAnimationType()
            if animationString != Config.defaultAnimationValue {
                animationStrings.insert(animationString)
            }
        }
    }

    private func initialiseAudios() {
        guard let audios = realm?.objects(Audio.self) else {
            return
        }
        for audio in audios {
            let audioString = audio.getAudioFile()
            if audioString != Config.defaultAudioValue {
                audioStrings.insert(audioString)
            }
        }
    }

    private func initialiseAudioGroups() {
        guard let groups = realm?.objects(AudioGroup.self) else {
            return
        }
        for group in groups {
            audioGroups.insert(group.getGroupName())
        }
    }

    func saveSession(_ sessionName: String, _ session: Session) -> Session? {
        var savedSession = session
        if session.getSessionName() != nil {
            savedSession = Session(session: session)
        }
        savedSession.prepareForSave(sessionName: sessionName)

        do {
            if !sessionNames.contains(sessionName) {
                try realm?.write { realm?.add(SessionName(sessionName)) }
            }
            try realm?.write { realm?.add(savedSession, update: true) }
        } catch {
            return nil
        }

        if !sessionNames.contains(sessionName) {
            self.sessionNames.insert(sessionName)
        }
        lastSessionName = sessionName
        return Session(session: session)
    }

    func editSessionName(oldSessionName: String, newSessionName: String) -> Bool {
        guard sessionNames.contains(oldSessionName) else {
            return false
        }

        guard let session = loadSession(oldSessionName) else {
            return false
        }

        guard removeSession(oldSessionName) else {
            return false
        }

        return saveSession(newSessionName, session) != nil
    }

    func removeSession(_ sessionName: String) -> Bool {
        guard sessionNames.contains(sessionName) else {
            return false
        }

        do {
            guard let session = loadExactSession(sessionName) else {
                return false
            }

            if let sessionNameObject = realm?.object(ofType: SessionName.self,
                                                     forPrimaryKey: sessionName) {
                try realm?.write { realm?.delete(sessionNameObject) }
            }

            try realm?.write {
                for pad in session.getPadList() {
                    realm?.delete(pad)
                }
                realm?.delete(session)
            }
        } catch {
            return false
        }

        sessionNames.remove(sessionName)

        return true
    }

    private func loadExactSession(_ sessionName: String) -> Session? {
        guard sessionNames.contains(sessionName) else {
            return nil
        }

        guard let session = realm?.object(ofType: Session.self, forPrimaryKey: sessionName) else {
                //handle error
                return nil
        }
        session.load()
        return session
    }

    func loadSession(_ sessionName: String) -> Session? {
        guard sessionNames.contains(sessionName) else {
            return nil
        }

        guard let session = realm?.object(ofType: Session.self, forPrimaryKey: sessionName) else {
                //handle error
                return nil
        }
        session.load()
        let copiedSession = Session(session: session)
        return copiedSession
    }

    func loadAllSessionNames() -> [String] {
        return Array(sessionNames)
    }

    func saveAnimation(_ animationString: String) -> Bool {
        if animationStrings.contains(animationString) {
            _ = removeAnimation(animationString)
        }

        do {
            try realm?.write { realm?.add(Animation(animationString)) }
        } catch {
            return false
        }

        if !animationStrings.contains(animationString) {
            self.animationStrings.insert(animationString)
        }

        return true
    }

    func removeAnimation(_ animationString: String) -> Bool {

        guard animationStrings.contains(animationString) else {
            return false
        }

        do {
            guard let animationObject = realm?.object(ofType: Animation.self, forPrimaryKey: animationString) else {

                return false
            }
            try realm?.write { realm?.delete(animationObject) }
        } catch {
            return false
        }

        animationStrings.remove(animationString)

        return true

    }

    func loadAllAnimationTypes() -> [String] {
        return Array(animationStrings)
    }

    func saveAudio(_ audioFile: String) -> Bool {
        if audioStrings.contains(audioFile) {
            _ = removeAudio(audioFile)
        }

        do {
            try realm?.write { realm?.add(Audio(audioFile)) }
        } catch {
            return false
        }

        if !audioStrings.contains(audioFile) {
            self.audioStrings.insert(audioFile)
        }
        return true
    }

    func removeAudio(_ audioFile: String) -> Bool {
        guard audioStrings.contains(audioFile) else {
            return false
        }

        do {
            guard let audioObject = realm?.object(ofType: Audio.self, forPrimaryKey: audioFile) else {

                return false
            }
            try realm?.write { realm?.delete(audioObject) }
        } catch {
            return false
        }

        audioStrings.remove(audioFile)

        return true

    }

    func loadAllAudioStrings() -> [String] {
        return Array(audioStrings)
    }

    func loadLastSession() -> Session? {
        if let lastSessionName = self.lastSessionName {
            return loadSession(lastSessionName)
        } else {
            return nil
        }
    }

    func getSamplesForGroup(group: String) -> [String] {
        guard let audiosResultObject = realm?.objects(Audio.self).filter("audioGroup = %@", group) else {
            return []
        }
        var samples = [String]()
        audiosResultObject.forEach({ audio in
            samples.append(audio.getAudioFile())
        })
        return samples
    }

    //Returns false if the sample does not exist in the database
    func addSampleToGroup(group: String, sample: String) -> Bool {
        guard audioStrings.contains(sample) else {
            return false
        }
        guard let audio = realm?.object(ofType: Audio.self, forPrimaryKey: sample) else {
            return false
        }
        do {
            try realm?.write {
                audio.setAudioGroup(group: group)
                //Create group
                if !audioGroups.contains(group) {
                    realm?.add(AudioGroup(group))
                    audioGroups.insert(group)
                }
            }
        } catch {
            return false
        }
        return true

    }

    func getAllGroups() -> [String] {
        return Array(audioGroups)
    }
}
