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
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            //Need to Handle error
            self.realm = nil
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
    
    func loadAllSessionNames() -> [Session] {
        return []

    }
    
    func saveAnimation(_ animation: AnimationSequence) -> Bool {
        return false
    }
    
    func loadAllAnimations() -> [AnimationSequence] {
        return []
    }
    
    func saveAudio(_ audioFile: String) -> Bool {
        return false
    }
    
    func loadAllAudioStrings() -> [String] {
        return []
    }
    
}
