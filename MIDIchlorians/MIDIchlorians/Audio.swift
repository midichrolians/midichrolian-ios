//
//  Audio.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 23/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift

class Audio: Object {
    private dynamic var audioFile: String?
    func addAudio(_ audioFile: String) {
        self.audioFile = audioFile
    }

    func getAudioFile() -> String? {
        return audioFile
    }
}
