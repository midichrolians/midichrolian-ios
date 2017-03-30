//
//  Animation.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

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
