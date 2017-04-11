//
//  AudioPlayer.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 28/2/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    public static var instance = AudioManager(Config.audioSetting)
    private var audioClipDict: [String: UInt32]
    private var audioTrackDict: [String: AVAudioPlayer]
    private var loopDict: [String:Timer]
    private var audioPlayerType: AudioPlayerSetting
    private let AUDIOCLIPLIMIT: Double = 30
    //only needs to be a small enough number such that there's a low buffer (cant be zero)
    private let LOWBUFFERDURATION = 0.0002

    init(_ setting: AudioPlayerSetting) {
        audioClipDict = [String: UInt32]()
        audioTrackDict = [String: AVAudioPlayer]()
        loopDict = [String: Timer]()
        audioPlayerType = setting
        do {
            let sharedSessionIntance = AVAudioSession.sharedInstance() as AVAudioSession
            try sharedSessionIntance.setActive(true)
            try sharedSessionIntance.setPreferredIOBufferDuration(LOWBUFFERDURATION)
        } catch {
            print("audioSession error")
        }
    }

    //initialize single audio file
    //returns successs
    func initAudio(audioDir: String) -> Bool {
        //want if nil means not initialized yet
        guard audioClipDict[audioDir] == nil && audioTrackDict[audioDir] == nil else {
            return true
        }
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
                //print("initializing")
                return initAudioTrack(audioDir: audioDir)
            case AudioPlayerSetting.gSAudio:
                return initAudioTrack(audioDir: audioDir)
        }
    }

    // for avAudioplayer (not system sounds)
    private func initAudioTrack(audioDir: String) -> Bool {
        print("initializing Audio Track")
        guard let avTrackPlayer = AudioTrackPlayer.initAudioTrack(audioDir: audioDir) else {
            return false
        }
        audioTrackDict[audioDir] = avTrackPlayer
        return true
    }

    //call this to play audio with single directory
    //returns success
    func play(audioDir: String, bpm: Int? = nil) -> Bool {
        guard let beatsPerMin = bpm else {
            if audioDuration(for: audioDir) >= AUDIOCLIPLIMIT {
                return playLongTrack(audioDir: audioDir)
            } else {
               return tryAudioClip(audioDir: audioDir)
            }

        }

        playLoop(audioDir: audioDir, bpm: beatsPerMin)
        return true
    }

    private func playLongTrack(audioDir: String) -> Bool {
        guard let player = audioTrackDict[audioDir] else {
            if initAudio(audioDir: audioDir) {
                return playAudioTrack(audioDir: audioDir)
            } else {
                return false
            }
        }

        if AudioTrackPlayer.isPlaying(audioPlayer: player) {
            return AudioTrackPlayer.stopAudioTrack(audioPlayer: player)
        } else {
            return playAudioTrack(audioDir: audioDir)
        }
    }

    private func tryAudioClip(audioDir: String) -> Bool {
        guard let audio = audioClipDict[audioDir] else {
            return tryAudioTrack(audioDir: audioDir)
        }

        AudioClipPlayer.playAudioClip(soundID: audio)
        return true
    }

    private func tryAudioTrack(audioDir: String) -> Bool {
        guard let audioTrack = audioTrackDict[audioDir] else {
            GSAudio.sharedInstance.playSound(audioDir: audioDir)
            return false
        }
        AudioTrackPlayer.playAudioTrack(audioPlayer: audioTrack)
        return true
    }

    private func playLoop(audioDir: String, bpm: Int) {
        if loopDict[audioDir] == nil {
            let secondsPerBeat: Double = 60.0 / Double(bpm)
            loopDict[audioDir] = Timer.scheduledTimer(timeInterval: secondsPerBeat,
                                                      target: self,
                                                      selector: #selector(self.runTimedCode(_:)),
                                                      userInfo: audioDir,
                                                      repeats: true)
        } else {
            stop(audioDir: audioDir)
        }
    }

    //has to expose to objc to be target of selector
    @objc func runTimedCode(_ timer: Timer) {
        guard let audioDir = timer.userInfo as? String else {
            return
        }
        _ = play(audioDir: audioDir)
    }

    func isTrackPlaying(audioDir: String) -> Bool {
        if let player = audioTrackDict[audioDir] {
            return player.isPlaying
        } else if let timer = loopDict[audioDir] {
            return true
        }
        return false
    }

    private func playAudioTrack(audioDir: String) -> Bool {
        guard let audio = audioTrackDict[audioDir] else {
            if initAudio(audioDir: audioDir) {
                return play(audioDir: audioDir)
            } else {
                return false
            }
        }
        AudioTrackPlayer.playAudioTrack(audioPlayer: audio)
        return true
    }

    private func audioDuration(for resource: String) -> Double {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
                                                        return -1
        }
        let soundURL = docsURL.appendingPathComponent("\(resource)")
        let asset = AVURLAsset(url: soundURL)
        return Double(CMTimeGetSeconds(asset.duration))
    }

    func getDuration(for resource: String) -> String {
        let durNum = audioDuration(for: resource)
        if durNum < 0 {
            return ""
        }
        let minutes:Int = Int(durNum) % 3600 / 60
        let seconds:Int = (Int(durNum) % 3600) % 60
        return "\(minutes) min \(seconds) seconds"
    }
    
    //ideally should stop a looping track
    func stop(audioDir: String) {
        guard let audioTimer = loopDict[audioDir] else {
            return
        }
        audioTimer.invalidate()
        loopDict[audioDir] = nil
    }
}
