//
//  Pad.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 16/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

struct Pad {
    
    private var audioFile: String?
    
    //TODO: Replace audioFile with struct
    mutating func addAudio(audioFile: String) {
        self.audioFile = audioFile
    }
    
    mutating func addAnimation(animation: AnimationSequence) {
        
    }
    
    //Should return audio struct
    func getAudio() -> String? {
        return audioFile
    }
    
    func getAnimation() -> AnimationSequence? {
        return nil
    }
    
    mutating func clearAudio() {
        self.audioFile = nil
    }
    
    mutating func clearAnimation() {
    }
    
    func savePad() {
        
    }
    
    func loadPad() {
        
    }
}
