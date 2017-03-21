//
//  SessionSaver.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 18/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift
//TODO: Take care of unwrapped optionals

class SessionSaver {
    static let realm = try! Realm()
    static let sessionNameQueryString = "sessionName = %@"
    
    static func saveSession(_ sessionName: String, _ session: Session) -> Bool {
        session.prepareForSave(sessionName: sessionName)
        try! realm.write {
            realm.add(session)
        }
        return true
    }
    
    static func loadSession(_ sessionName: String) -> Session {
        let session = realm.objects(Session.self).filter(sessionNameQueryString, sessionName).first
        session.load()
        return session
    }
}
