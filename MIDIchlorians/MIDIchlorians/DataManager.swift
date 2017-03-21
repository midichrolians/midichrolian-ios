//
//  SessionSaver.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 18/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift
//TODO: Take care of unwrapped optionals

class DataManager {
    static let realm = try! Realm()
    static let sessionNameQueryString = "sessionName = %@"
    
    static func saveSession(_ sessionName: String, _ session: Session) -> Bool {
        session.prepareForSave(sessionName: sessionName)
        try! realm.write {
            realm.add(session)
        }
        return true
    }
    
    static func loadSession(_ sessionName: String) -> Session? {
        guard let session = realm.objects(Session.self)
            .filter(sessionNameQueryString, sessionName)
            .first else {
                //handle error
                return nil
        }
        session.load()
        return session
    }
    
    static func loadAllSessionNames() -> [Session] {
        return []

    }
    
    static func saveAnimation(_ animation: AnimationSequence) -> Bool {
        return false
    }
    
    static func loadAllAnimations() -> [AnimationSequence] {
        return []
    }
    
    static func saveAudio(_ audioFile: String) -> Bool {
        return false
    }
    
    static func loadAllAudioStrings() -> [String] {
        return []
    }
    
}
