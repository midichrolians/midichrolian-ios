//
//  AudioPlayer.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 28/2/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioManager {
    static let instance = AudioManager()
    private var audioDict: [String:UInt32]

    init() {
        audioDict = [String: UInt32]()
    }

    //initialize single audio file
    //returns successs
    private mutating func initAudio(audioDir: String) -> Bool {
        guard let audioID = AudioClipPlayer.initAudioClip(audioDir: audioDir) else {
            return false
        }
        audioDict[audioDir] = audioID
        return true
    }

    //returns success
    mutating func loadAllAudio() -> Bool {
       //load all audio from DataManager
        return true
    }

    //call this to play audio with single directory
    //returns success
    func play(audioDir: String, bpm: Int? = nil ) -> Bool {
        guard let audioID = audioDict[audioDir] else {
            return false
        }
        AudioClipPlayer.playAudioClip(soundID: audioID)
        return true
    }

    //ideally should stop a looping track
    func stop(audioDir: String) {

    }
}
