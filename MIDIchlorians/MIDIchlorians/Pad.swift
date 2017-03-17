//
//  Pad.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 16/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//


//Model should have reference to this?
import RealmSwift

class Pad: Object {
    //Realm needs dynamic var type to persist data
    dynamic var row: Int = 0
    dynamic var col: Int = 0
    //Need to Store animation in some form
    dynamic var audioFile: String?
    
    convenience init(row: Int, col: Int) {
        self.init()
        self.row = row
        self.col = col
    }
    
    //TODO: Replace audio with struct
    func addAudio(audioFile: String) {
        self.audioFile = audioFile
    }
    
    func addAnimation(animation: AnimationSequence) {
        
    }
    
    //Should return audio struct
    func getAudio() -> String? {
        return audioFile
    }
    
    func getAnimation() -> AnimationSequence? {
        return nil
    }
}
