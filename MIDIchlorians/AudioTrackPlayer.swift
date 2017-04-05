//
//  AudioTrackPlayer.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 1/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioTrackPlayer {
    static func initAudioTrack (audioDir: String, ext: String = "wav") -> AVAudioPlayer? {
        guard let audioURL = Bundle.main.url(forResource: audioDir, withExtension: ext) else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: audioURL)
            player.prepareToPlay()
            return player
        } catch {
            print("AVAudioPlayer Error")
        }
        return nil
    }

    static func playAudioTrack (audioPlayer: AVAudioPlayer) {
        if audioPlayer.isPlaying {
            audioPlayer.currentTime = 0
        } else {
            audioPlayer.play()
        }
    }
}
