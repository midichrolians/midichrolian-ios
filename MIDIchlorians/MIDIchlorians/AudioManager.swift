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
    private var audioDict: [String: UInt32]
    private var audioPlayerType: AudioPlayerSetting

    init(_ setting: AudioPlayerSetting) {
        audioDict = [String: UInt32]()
        audioPlayerType = setting
/*
        do {
            let sharedSessionIntance = AVAudioSession.sharedInstance() as AVAudioSession
            try sharedSessionIntance.setActive(true)
            try sharedSessionIntance.setPreferredIOBufferDuration(0.0002)
        } catch {
            print("audioSession error")
        }
 */
    }

    //initialize single audio file
    //returns successs
    mutating func initAudio(audioDir: String) -> Bool {
        guard let audioID = AudioClipPlayer.initAudioClip(audioDir: audioDir) else {
            return false
        }
        /*
        switch audioPlayerType {
            
        }*/
        audioDict[audioDir] = audioID
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

    func hackCheckValidIndex(row: Int, col: Int) -> Bool {
        let rowMax = Config.sound.count
        let colMax = Config.sound[0].count
        return row >= 0 && row < rowMax && col >= 0 && col < colMax
    }

    //ideally should stop a looping track
    func stop(audioDir: String) {

    }
}
