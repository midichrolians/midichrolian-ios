//
//  AudioPlayer.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 28/2/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import Foundation
import AVFoundation

/**
 Singleton, access the audio players from here. Will take in an enum (audioPlayerSetting) to choose which audioplayer to use
 AudioPlayerSetting = 
 gSAudio: newest setting, uses GS audio for all short clips, uses AudioTrackPlayer for Long clips and loops
 aVAudioPlayer: Uses AudioTrackPlayer for all audios,all lengths and loops. will have distortion when playing short clips
 audioServices: oldest setting, uses AudioClipPlayer (running on audio services) for short clips and loops, AudioTrackPlayer for long clips
 */
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
    //returns success
    //chooses method based on the audioPlayerType
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
    //checks for audio duration for clips longer than 30 seconds
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

            let newTimer = Timer.scheduledTimer(timeInterval: secondsPerBeat,
                                                  target: self,
                                                  selector: #selector(self.runTimedCode(_:)),
                                                  userInfo: audioDir,
                                                  repeats: true)
            RunLoop.main.add(newTimer, forMode: RunLoopMode.commonModes)
            loopDict[audioDir] = newTimer
        } else {
            stop(audioDir: audioDir)
        }
    }

    //has to expose to objc to be target of selector
    //for playing of loops
    @objc func runTimedCode(_ timer: Timer) {
        guard let audioDir = timer.userInfo as? String else {
            return
        }
        _ = play(audioDir: audioDir)
    }

    //returns if the track is playing or not. only works with AudioTrackPlayer or loops
    func isTrackPlaying(audioDir: String) -> Bool {
        if let player = audioTrackDict[audioDir] {
            return player.isPlaying
        } else if loopDict[audioDir] != nil {
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

    //returns audio duration in X min X seconds format. not used in UI as of submission, but can be implemented if required
    func getDuration(for resource: String) -> String {
        let durNum = audioDuration(for: resource)
        if durNum < 0 {
            return ""
        }
        let minutes: Int = Int(durNum) % 3600 / 60
        let seconds: Int = (Int(durNum) % 3600) % 60
        return "\(minutes) min \(seconds) seconds"
    }

    //stops looping tracks
    func stop(audioDir: String) {
        guard let audioTimer = loopDict[audioDir] else {
            return
        }
        audioTimer.invalidate()
        loopDict[audioDir] = nil
    }
}
