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

    init?() {
        do {
            self.realm = try Realm()
        } catch {
            return nil
        }
    }

    func saveSession(_ sessionName: String, _ session: Session) -> Bool {
        session.prepareForSave(sessionName: sessionName)
        do {
            try realm?.write { realm?.add(session) }
        } catch {
            return false
        }
        return true
    }

    func loadSession(_ sessionName: String) -> Session? {
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
//        guard let sessionNames = realm?.objects(Session.self).map({ (session) -> String in
//            return session.getSessionName()
//        }) else {
//            return []
//        }

        return []
    }

    func saveAnimation(_ animation: AnimationSequence) -> Bool {
        //Check if database already has the post in it
        //What if it already exists?
        do {
            try realm?.write { realm?.add(Animation(value: animation)) }
        } catch {
            return false
        }
        return true
    }

    func loadAllAnimations() -> [AnimationSequence] {
        return []
    }

    func saveAudio(_ audioFile: String) -> Bool {
        //What if it already exists?
        do {
            try realm?.write { realm?.add(Audio(value: audioFile)) }
        } catch {
            return false
        }
        return true
    }

    func loadAllAudioStrings() -> [String] {
        return []
    }
}
