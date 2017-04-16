//
//  RecorderManager.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 8/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

/**
 Recording singleton
 access all recording from this class.
 uses TimeTracker to track which buttons are pressed(via delegate)
 and PlayBackRetriever to retrieve the next pads to be "tapped"
 */

class RecorderManager {
    static let instance = RecorderManager()

    //for recording
    private var recordingStarted = false
    private var timeTracker: TimeTracker

    //for playback
    private var playBack: PlayBackRetriever
    private var toPlay = [(TimeInterval, (Int, IndexPath))]()
    private var playClock: TimeInterval = 0
    private var playingStarted = false
    private var playTimer: Timer?
    weak var delegate: RecordPlaybackDelegate?

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

    func recordPad(forPage pageNum: Int, forIndex indexPath: IndexPath) {
        guard recordingStarted && !playingStarted else {
            return
        }
        timeTracker.setTimePadPair(pageNum: pageNum, forIndex: indexPath)
    }

    //creates a timer of 60fps to play back the recording
    func startPlay() {
        playingStarted = true
        playClock = 0
        playBack = PlayBackRetriever(timeIndexArr: timeTracker.timePathDict)
        playTimer = Timer.scheduledTimer(timeInterval: Config.playBackAccuracy,
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

    //calls pads to be tapped
    //every time a set of pads is being "tapped", it retrieves the next set of pads
    //it then waits for the timer to be greater than or equals to the timer of those pads and taps those
    @objc func runTimedCode(_ timer: Timer) {
        playClock += Config.playBackAccuracy
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
                let pageNum = value.1.0
                let indexPath = value.1.1
                delegate?.playPad(page: pageNum, indexPath: indexPath)
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
