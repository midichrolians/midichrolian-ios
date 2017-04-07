//
//  RecorderManager.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 8/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

class RecorderManager {
    static let instance = RecorderManager()

    //for recording
    private var recordingStarted = false
    private var timeTracker: TimeTracker

    //for playback
    private var playBack: PlayBackRetriever
    private let TIMEINTERVAL: TimeInterval = 1/60
    private var toPlay = [(TimeInterval, (Int, IndexPath))]()
    private var playClock: TimeInterval = 0
    private var playingStarted = false
    private var playTimer: Timer?

    init() {
        playBack = PlayBackRetriever(timeIndexArr: [(TimeInterval, (Int, IndexPath))]())
        playTimer = nil
        timeTracker = TimeTracker()
    }

    func startRecord() {
        timeTracker = TimeTracker()
        recordingStarted = true
    }

    func stopRecord() {
        recordingStarted = false
    }

    func recordPad (forPage pageNum: Int, forIndex indexPath: IndexPath) {
        guard recordingStarted && !playingStarted else {
            return
        }
        timeTracker.setTimePadPair(pageNum: pageNum, forIndex: indexPath)
    }

    func startPlay() {
        playingStarted = true
        playClock = 0
        playBack = PlayBackRetriever(timeIndexArr: timeTracker.timePathDict)
        playTimer = Timer.scheduledTimer(timeInterval: TIMEINTERVAL,
                                         target: self,
                                         selector: #selector(self.runTimedCode),
                                         userInfo: nil,
                                         repeats: true)
    }

    func stopPlay() {
        playingStarted = false
        playBack = PlayBackRetriever(timeIndexArr: [(TimeInterval, (Int, IndexPath))]())
        if playTimer != nil {
            playTimer?.invalidate()
            playTimer = nil
        }
    }

    @objc func runTimedCode(_ timer: Timer) {
        playClock += TIMEINTERVAL
        if toPlay.count <= 0 {
            toPlay = playBack.getNextPads()
            if toPlay.count <= 0 {
                timer.invalidate()
                playingStarted = false
                return
            }
        }
        let playTimeInt = toPlay[0].0
        if playClock >= playTimeInt {
            for value in toPlay {
                //TODO: Call pad to be played here
                print("page", value.1.0, "index", value.1.1)
            }
            toPlay = [(TimeInterval, (Int, IndexPath))]()
        }
    }

    var isRecording: Bool {
        return recordingStarted
    }

    var isPlaying: Bool {
        return playingStarted
    }
}
