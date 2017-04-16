//
//  ClipAudioPlayer.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 21/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import AVFoundation
//perferbably 30 seconds or shorter only
//need to check if have problems with longer clips

struct AudioClipPlayer {

    //creates ID and returns it to be mapped
    static func initAudioClip(audioDir: String) -> UInt32? {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
            return nil
        }
        let soundURL = docsURL.appendingPathComponent("\(audioDir)")
        var sysID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &sysID)
        return sysID
    }

    //plays based on ID
    static func playAudioClip(soundID: UInt32) {
        AudioServicesPlaySystemSound(soundID)
    }
}
