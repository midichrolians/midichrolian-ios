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

    //TODO: REALM INIT CAN FAIL
    private init() {
        // Not sure if this line should always be there
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        self.realm = try? Realm()
        sessionNames = Set<String>()
        animationStrings = Set<String>()
        audioStrings = Set<String>()
        initialiseSessionNames()
        initialiseAnimations()
        initialiseAudios()
    }

    private func initialiseSessionNames() {
        guard let sessionNames = realm?.objects(SessionName.self) else {
            return
        }
        for sessionName in sessionNames {
            if let sessionNameString = sessionName.getSessionName() {
                self.sessionNames.insert(sessionNameString)
            }
        }
    }

    private func initialiseAnimations() {
        guard let animations = realm?.objects(Animation.self) else {
            return
        }
        for animation in animations {
            if let animationString = animation.getAnimationString() {
                animationStrings.insert(animationString)
            }
        }
    }

    private func initialiseAudios() {
        guard let audios = realm?.objects(Audio.self) else {
            return
        }
        for audio in audios {
            if let audioString = audio.getAudioFile() {
                audioStrings.insert(audioString)
            }
        }
    }

    func saveSession(_ sessionName: String, _ session: Session) -> Bool {

        if sessionNames.contains(sessionName) {
            _ = removeSession(sessionName)
        }
        session.prepareForSave(sessionName: sessionName)

        do {
            try realm?.write { realm?.add(SessionName(sessionName)) }
            try realm?.write { realm?.add(session) }

        } catch {
            return false
        }

        if !sessionNames.contains(sessionName) {
            self.sessionNames.insert(sessionName)
        }

        return true
    }

    func removeSession(_ sessionName: String) -> Bool {
        guard sessionNames.contains(sessionName) else {
            return false
        }

        do {
            guard let session = loadSession(sessionName) else {
                return false
            }

            if let sessionNameObject = realm?.objects(SessionName.self)
                                             .filter("sessionName = %@", sessionName).first {
                try realm?.write { realm?.delete(sessionNameObject) }
            }

            try realm?.write { realm?.delete(session) }
        } catch {
            return false
        }

        sessionNames.remove(sessionName)

        return true
    }

    func loadSession(_ sessionName: String) -> Session? {
        guard sessionNames.contains(sessionName) else {
            return nil
        }

        guard let session = realm?.objects(Session.self)
                                  .filter("sessionName = %@", sessionName)
                                  .first else {
                //handle error
                return nil
        }
        session.load()
        return session
    }

    func loadAllSessionNames() -> [String] {
        return Array(sessionNames)
    }

    func saveAnimation(_ animation: AnimationSequence) -> Bool {
        guard let animationString = animation.getJSONforAnimationSequence() else {
            return false
        }

        if animationStrings.contains(animationString) {
            _ = removeAnimation(animation)
        }

        do {
            try realm?.write { realm?.add(Animation(animation)) }
        } catch {
            return false
        }

        if !animationStrings.contains(animationString) {
            self.animationStrings.insert(animationString)
        }

        return true
    }

    func removeAnimation(_ animation: AnimationSequence) -> Bool {
        guard let animationString = animation.getJSONforAnimationSequence() else {
            return false
        }

        guard animationStrings.contains(animationString) else {
            return false
        }

        do {
            guard let animationObject = realm?.objects(Animation.self)
                                              .filter("animationString = %@", animationString)
                                              .first else {

                return false
            }
            try realm?.write { realm?.delete(animationObject) }
        } catch {
            return false
        }

        animationStrings.remove(animationString)

        return true

    }

    func loadAllAnimations() -> [AnimationSequence] {
        var finalArray = [AnimationSequence]()
        for animationString in Array(animationStrings) {
            if let animation = AnimationSequence.getAnimationSequenceFromJSON(fromJSON: animationString) {
                finalArray.append(animation)
            }
        }
        return finalArray
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
            guard let audioObject = realm?.objects(Audio.self)
                .filter("audioFile = %@", audioFile)
                .first else {

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
}
