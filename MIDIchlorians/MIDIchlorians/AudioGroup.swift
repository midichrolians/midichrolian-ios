//
//  AudioGroup.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 8/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift
/**
 This class represents an Audio group in the Database, which is a wrapper around a String. The
 String represents the name of the group.

 Created this as we want to support the query of getting all groups in an efficient manner. (Similar
 to the case of Session Name)
 
 Since the default initialiser is valid because of Realm classes inheriting Object, the value of
 group is an optional, so as to ensure that AudioGroups created using the default
 initialiser are invalid. For correct results, the convenience initialisers defined below must be used.
 **/
class AudioGroup: Object {

    private dynamic var group: String?

    convenience init(_ group: String) {
        self.init()
        self.group = group
    }

    override static func primaryKey() -> String? {
        return "group"
    }

    func getGroupName() -> String? {
        return group
    }
}
