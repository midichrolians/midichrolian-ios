//
//  Pad.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 16/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

/**
 This class represents a single Pad in a grid. A pad may have a track(audio file) and an animation
 assigned to it. A pad may also have a BPM value, indicating the number of 
 beats per minute at which the corresponding audio track plays.
 These properties are supported via optionals, since they may or may not exist. One exception
 is the BPM field, since Realm has it's own syntax for Integer optionals, which I did not want to 
 use as it causes a few issues. To someone calling the functions, the BPM property can be treated 
 as an optional, even though under the hood it is implemented differently.
 
 Using a class because Realm can't deal with structs.
 */
class Pad: Object {

    // Persisted properties. Dynamic is a realm requirement
    private dynamic var audioFile: String?
    private dynamic var animationString: String?
    // Not using an optional because Realm has special syntax for integer optionals, which 
    // leads to issues for our requirements
    private dynamic var BPM: Int = Config.invalidBPM

    // An initialser to create a pad which is a copy of another one
    convenience init(_ pad: Pad) {
        self.init()
        self.audioFile = pad.audioFile
        self.animationString = pad.animationString
        self.BPM = pad.BPM
    }

    // Constructs a pad object from a JSON string. This method is useful when saving sessions
    // to JSON files, to enable sharing between different users.
    convenience init?(json: String) {
        self.init()
        guard let data = json.data(using: .utf8) else {
            return nil
        }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: []))
                                as? [String: Any?] else {
            return nil
        }
        self.audioFile = dictionary["audioFile"] as? String
        self.animationString = dictionary["animationString"] as? String
        self.BPM = (dictionary["BPM"] as? Int) ?? Config.invalidBPM
    }

    func setBPM(bpm: Int) {
        self.BPM = bpm
    }

    func addAudio(audioFile: String) {
        self.audioFile = audioFile
    }

    func addAnimation(animation: AnimationSequence) {
        animationString = animation.getJSON()
    }

    // Returns nil in case no BPM was assigned(i.e. the value of the BPM is invalid)
    // This way, someone calling the functions can treat it as an optional
    func getBPM() -> Int? {
        guard self.BPM != Config.invalidBPM else {
            return nil
        }
        return self.BPM
    }

    func getAudioFile() -> String? {
        return audioFile
    }

    func getAnimation() -> AnimationSequence? {
        guard let animationJSON = animationString else {
            return nil
        }
        return AnimationSequence(fromJSON: animationJSON)
    }

    func clearAudio() {
        self.audioFile = nil
    }

    func clearAnimation() {
        self.animationString = nil
    }

    func clearBPM() {
        self.BPM = Config.invalidBPM
    }

    // Since Pad inherits from Object, which inherits from NSObject, need to override this function
    // for checking equality (NSObject already conforms to Equatable protocol)
    override func isEqual(_ object: Any?) -> Bool {
        guard let pad = object as? Pad else {
            return false
        }
        return self.audioFile == pad.audioFile && self.animationString == pad.animationString
        && self.BPM == pad.BPM
    }

    func toJSON() -> String? {
        var dictionary = [String: Any?]()
        dictionary["audioFile"] = audioFile
        dictionary["animationString"] = animationString
        dictionary["BPM"] = BPM
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
