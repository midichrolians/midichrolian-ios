//
//  lowLatencyAudio.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 3/3/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import Foundation
import AudioToolbox

class LowLatencyAudioPlayer {
    static func playAudio() {
        guard let soundURL = Bundle.main.url(forResource: "../Samples/clap-808", withExtension: "wav") else {
            return
        }
        var testSound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &testSound)
        AudioServicesPlaySystemSound(testSound)
    }
}
