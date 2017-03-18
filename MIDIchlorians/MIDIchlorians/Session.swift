//
//  Session.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 16/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

struct Session {
    
    private let BPM: Int
    private let numPages: Int
    private let numRows: Int
    private let numCols: Int
    private var pads: [[[Pad]]]
    
    //ONLY NEED TO SAVE PADS WITH AUDIO/ANIMATION
    
    init(bpm: Int, numPages: Int, numRows: Int, numCols: Int) {
        self.BPM = bpm
        self.numPages = numPages
        self.numRows = numRows
        self.numCols = numCols
        self.pads = [[[Pad]]]()
        initalisePadGrid()
    }
    
    private mutating func initalisePadGrid() {
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
    
    mutating func addAudio(page: Int, row: Int, col: Int, audioFile: String) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].addAudio(audioFile: audioFile)
        
    }
    
    mutating func clearAudio(page: Int, row: Int, col: Int) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].clearAudio()
    }
    
    mutating func addAnimation(page: Int, row: Int, col: Int) {
        guard isValidPosition(page, row, col) else {
            return
        }
        
    }
    
    mutating func clearAnimation(page: Int, row: Int, col: Int) {
        guard isValidPosition(page, row, col) else {
            return
        }
        
    }
    
    private func isValidPosition(_ page: Int, _ row: Int, _ col: Int) -> Bool {
        return page < numPages && page >= 0 &&
            row < numRows && row >= 0 &&
            col < numCols && col >= 0
    }
    
    func saveSession() {
        
    }
    
    func loadSession() {
        
    }
    
}
