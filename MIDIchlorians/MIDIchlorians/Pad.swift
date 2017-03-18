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
    //private dynamic var animationString: String?
    
    //Properties for normal manipulation
    private var animation: AnimationSequence?
    //private var audio: Audio
    
    
    //Tells Realm that thse properties should not be persisted
    override static func ignoredProperties() -> [String] {
        //add audio here
        return ["animation"]
    }
    
    //Currently here for testing, ideally this method should take an audio struct
    func addAudio(audioFile: String) {
        self.audioFile = audioFile
    }
    
    func addAnimation(animation: AnimationSequence) {
        self.animation = animation
    }
    
    //Should ideally return audio struct
    func getAudio() -> String? {
        return audioFile
    }
    
    func getAnimation() -> AnimationSequence? {
        return animation
    }
    
    func clearAudio() {
        //self.audio = nil
        self.audioFile = nil
    }
    
    func clearAnimation() {
        self.animation = nil
        //self.animationString = nil
    }
    
    //Deserialise animation and object into strings and store in persisted properties
    func prepareForSave() {
        
    }
    
    //Use persisted properties to deserialise the audio and animation
    func load() {
        
    }

}
