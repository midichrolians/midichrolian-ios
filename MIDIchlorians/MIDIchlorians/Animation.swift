//
//  Animation.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift
/**
 This class represents an Animation in the Database, which is a wrapper around a JSON String. The
 JSON String represents an Animation Type
 
 Since the default initialiser is valid because of Realm classes inheriting Object, the value of 
 animationString is an optional, so as to ensure that Animations created using the default
 initialiser are invalid. For correct results, the convenience initialisers defined below must be used.
 **/
class Animation: Object {

    private dynamic var animationString: String?

    convenience init(_ animationType: String) {
        self.init()
        self.animationString = animationType
    }

    override static func primaryKey() -> String? {
        return "animationString"
    }

    func getAnimationType() -> String? {
        return animationString
    }

}
