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

    private var audioDict: [String:Int]
    
    init() {
        audioDict = [String:Int]()
    }

    //initialize single audio file
    func initAudio(audioDir: String) {
        
    }
    
    //initialize array of audio files
    func initAudios(audioDirs: [String]){
        
    }
    
    //call this to play audio with single directory
    func play(audioDir: String) {
        
    }
    
    func stop(audioDir: String) {
        
    }
}
