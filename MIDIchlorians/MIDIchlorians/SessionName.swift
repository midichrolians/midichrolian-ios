//
//  SessionName.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 25/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift
/**
 This class represents a Session name in the Database, which is a wrapper around a String. The
 String represents the name of a session.
 
 Created this as we want to support the query of getting all session names, and I wanted to do 
 that without having to load all the sessions(since Realm only allows us to load an entire object,
 and not a single property of the object)
 
 Since the default initialiser is valid because of Realm classes inheriting Object, the value of
 sessionName is an optional, so as to ensure that Session Name objects created using the default
 initialisers are invalid. For correct results, the convenience initialisers defined below must be used.
 **/
class SessionName: Object {

    private dynamic var sessionName: String?

    convenience init(_ sessionString: String) {
        self.init()
        self.sessionName = sessionString
    }

    override static func primaryKey() -> String? {
        return "sessionName"
    }

    func getSessionName() -> String? {
        return sessionName
    }
}
