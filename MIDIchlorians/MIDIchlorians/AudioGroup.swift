//
//  AudioGroup.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 8/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

class AudioGroup: Object {

    private dynamic var group: String = ""

    convenience init(_ group: String) {
        self.init()
        self.group = group
    }

    override static func primaryKey() -> String? {
        return "group"
    }

    func getGroupName() -> String {
        return group
    }
}
