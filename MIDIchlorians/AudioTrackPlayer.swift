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
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
                                                        return nil
        }
        let soundURL = docsURL.appendingPathComponent("\(audioDir).\(ext)")
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
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
