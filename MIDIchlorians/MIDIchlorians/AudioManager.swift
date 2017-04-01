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
    public static var instance = AudioManager(Config.audioSetting)
    private var audioClipDict: [String: UInt32]
    private var audioTrackDict: [String: AVAudioPlayer]
    private var audioPlayerType: AudioPlayerSetting
    private let AUDIOCLIPLIMIT: Double = 30

    init(_ setting: AudioPlayerSetting) {
        audioClipDict = [String: UInt32]()
        audioTrackDict = [String: AVAudioPlayer]()
        audioPlayerType = setting
        do {
            let sharedSessionIntance = AVAudioSession.sharedInstance() as AVAudioSession
            try sharedSessionIntance.setActive(true)
            try sharedSessionIntance.setPreferredIOBufferDuration(0.0002)
        } catch {
            print("audioSession error")
        }
    }

    //initialize single audio file
    //returns successs
    mutating func initAudio(audioDir: String) -> Bool {
        switch audioPlayerType {
            case AudioPlayerSetting.audioServices:
                if audioDuration(for: audioDir) < AUDIOCLIPLIMIT {
                    //short audio clips
                    guard let audioID = AudioClipPlayer.initAudioClip(audioDir: audioDir) else {
                        return false
                    }
                    audioClipDict[audioDir] = audioID
                    return true
                } else {
                    return initAudioTrack(audioDir: audioDir)
                }
            case AudioPlayerSetting.aVAudioPlayer:
                print("initializing")
                return initAudioTrack(audioDir: audioDir)
        }
    }

    // for avAudioplayer (not system sounds)
    mutating func initAudioTrack(audioDir: String) -> Bool {
        guard let avTrackPlayer = AudioTrackPlayer.initAudioTrack(audioDir: audioDir) else {
            return false
        }
        audioTrackDict[audioDir] = avTrackPlayer
        return true
    }

    //call this to play audio with single directory
    //returns success
    func play(audioDir: String, bpm: Int? = nil) -> Bool {

        switch audioPlayerType {
        case AudioPlayerSetting.audioServices:
            let audioID = audioClipDict[audioDir] ?? AudioClipPlayer.initAudioClip(audioDir: audioDir)

            guard let audio = audioID else {
                return playAudioTrack(audioDir: audioDir, bpm: bpm)
            }

            AudioClipPlayer.playAudioClip(soundID: audio)
            return true
        case AudioPlayerSetting.aVAudioPlayer:
            return playAudioTrack(audioDir: audioDir, bpm: bpm)
        }

    }

    func playAudioTrack(audioDir: String, bpm: Int?) -> Bool {
        let avPlayer = audioTrackDict[audioDir] ?? AudioTrackPlayer.initAudioTrack(audioDir: audioDir)
        guard let audio = avPlayer else {
            return false
        }
        AudioTrackPlayer.playAudioTrack(audioPlayer: audio)
        return true
    }

    func hackCheckValidIndex(row: Int, col: Int) -> Bool {
        let rowMax = Config.sound.count
        let colMax = Config.sound[0].count
        return row >= 0 && row < rowMax && col >= 0 && col < colMax
    }

    private func audioDuration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }

    //ideally should stop a looping track
    func stop(audioDir: String) {

    }
}
