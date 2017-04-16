//
//  Audio.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift
/**
 This class represents an Audio in the Database, which is a wrapper around a String. The
 String represents the name of the audio file
 
 Audios are tied to Groups, which represent a logical collection of tracks (such as a song). An
 Audio object therefore has an optional property representing it's group name.
 
 Since the default initialiser is valid because of Realm classes inheriting Object, the value of
 audioFile is an optional, so as to ensure that Audios created using the default
 initialiser are invalid. For correct results, the convenience initialisers defined below must be used.
 **/
class Audio: Object {

    private dynamic var audioFile: String?
    private dynamic var audioGroup: String?

    convenience init(_ audioFile: String) {
        self.init()
        self.audioFile = audioFile
    }

    override static func primaryKey() -> String? {
        return "audioFile"
    }

    func getAudioFile() -> String? {
        return audioFile
    }

    func getAudioGroup() -> String? {
        return audioGroup
    }

    func setAudioGroup(group: String) {
        self.audioGroup = group
    }
}
