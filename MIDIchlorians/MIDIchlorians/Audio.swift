//
//  Audio.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

class Audio: Object {

    private dynamic var audioFile: String = Config.defaultAudioValue
    private dynamic var audioGroup: String?

    convenience init(_ audioFile: String) {
        self.init()
        self.audioFile = audioFile
    }

    override static func primaryKey() -> String? {
        return "audioFile"
    }

    func getAudioFile() -> String {
        return audioFile
    }

    func getAudioGroup() -> String? {
        return audioGroup
    }

    func setAudioGroup(group: String) {
        self.audioGroup = group
    }
}
