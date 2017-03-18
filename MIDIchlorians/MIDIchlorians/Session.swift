//
//  Session.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 16/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//
import RealmSwift

class Session: Object {
    
    dynamic private var BPM = 0 // Need to agree on a default value
    dynamic private var numPages = Config.numberOfPages
    dynamic private var numRows = Config.numberOfRows
    dynamic private var numCols = Config.numberOfColumns
    private let padList = List<Pad>()
    
    private var pads: [[[Pad]]] = []
    
    //Tells Realm that thse properties should not be persisted
    override static func ignoredProperties() -> [String] {
        return ["pads"]
    }
    
    private func initialisePadGrid() {
        for page in 0..<numPages {
            pads.append([])
            for row in 0..<numRows {
                pads[page].append([])
                for _ in 0..<numCols {
                    let emptyPad = Pad()
                    pads[page][row].append(emptyPad)
                }
            }
        }
    }
    
    //Should take audio struct
    func addAudio(page: Int, row: Int, col: Int, audioFile: String) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].addAudio(audioFile: audioFile)
        
    }
    
    func clearAudio(page: Int, row: Int, col: Int) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].clearAudio()
    }
    
    func addAnimation(page: Int, row: Int, col: Int, animation: AnimationSequence) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].addAnimation(animation: animation)
        
    }
    
    func clearAnimation(page: Int, row: Int, col: Int) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].clearAnimation()
        
    }
    
    private func isValidPosition(_ page: Int, _ row: Int, _ col: Int) -> Bool {
        return page < numPages && page >= 0 &&
            row < numRows && row >= 0 &&
            col < numCols && col >= 0
    }
    
}
