//
//  ClipAudioPlayer.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 21/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import AudioToolbox
//perferbably 30 seconds or shorter only
//need to check if have problems with longer clips

struct AudioClipPlayer {

    //creates ID and returns it to be mapped
    static func initAudioClip(audioDir: String, ext: String = "wav") -> UInt32? {
        guard let soundURL = Bundle.main.url(forResource: audioDir, withExtension: ext) else {
            return nil
        }
        let sysID: SystemSoundID = 0
        var testSound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &testSound)
        return sysID
    }

    //plays based on ID
    static func playAudioClip(soundID: UInt32) {
        AudioServicesPlaySystemSound(soundID)
    }
}
