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

    convenience init(_ animation: AnimationSequence) {
        self.init()
        self.animationString = animation.getJSONforAnimationSequence()
    }

    func getAnimationSequence() -> AnimationSequence? {
        guard let animationJSON = animationString else {
            return nil
        }
        return AnimationSequence.getAnimationSequenceFromJSON(fromJSON: animationJSON)
    }

    func getAnimationString() -> String? {
        return animationString
    }

}
