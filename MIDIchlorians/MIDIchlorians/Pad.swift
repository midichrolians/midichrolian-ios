//
//  Pad.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 16/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

/**
 As only specific datatypes can be persisted, the idea is to have 4 optional properties. One
 property is an Audio, and one is an Animation Sequence, as these are what define a Pad object. 
 The other two reprsent serialised versions of the 2 structures mentioned above, and only these 2 
 serialised properties will be persisted.
 
 Using a class because Realm can't deal with structs.
 */
class Pad: Object {

    //Persisted properties. Dynamic is a realm requirement
    private dynamic var audioFile: String?
    private dynamic var animationString: String?

    convenience init(_ pad: Pad) {
        self.init()
        self.audioFile = pad.audioFile
        self.animationString = pad.animationString
    }

    func addAudio(audioFile: String) {
        self.audioFile = audioFile
    }

    func addAnimation(animation: AnimationSequence) {
        animationString = animation.getJSONforAnimationSequence()
    }

    func getAudioFile() -> String? {
        return audioFile
    }

    func getAnimation() -> AnimationSequence? {
        guard let animationJSON = animationString else {
            return nil
        }
        return AnimationSequence.getAnimationSequenceFromJSON(fromJSON: animationJSON)
    }

    func clearAudio() {
        self.audioFile = nil
    }

    func clearAnimation() {
        self.animationString = nil
    }

    func equals(_ pad: Pad) -> Bool {
        return self.audioFile == pad.audioFile && self.animationString == pad.animationString
    }
}
