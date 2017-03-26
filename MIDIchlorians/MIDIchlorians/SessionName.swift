//
//  SessionName.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 25/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

class SessionName: Object {

    private var sessionName: String = ""

    convenience init(_ sessionString: String) {
        self.init()
        self.sessionName = sessionString
    }

    func getSessionName() -> String? {
        return sessionName
    }
}
