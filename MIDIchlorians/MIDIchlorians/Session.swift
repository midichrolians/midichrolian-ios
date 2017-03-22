//
//  Session.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 16/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//
import RealmSwift

/**
 This class represents a Session, which is a collection of grids, each grid being a collection
 of pads. A session also has a BPM associated with it.
 Though a default initialiser is valid(because of Realm), it will lead to incorrect results. 
 For correct results, use the convenience initialiser defined below.
 **/
class Session: Object {

    dynamic private var BPM = Config.defaultBPM
    dynamic private var numPages = Config.numberOfPages
    dynamic private var numRows = Config.numberOfRows
    dynamic private var numCols = Config.numberOfColumns
    dynamic private var sessionName = ""
    private var padList = List<Pad>()

    private var pads = [[[Pad]]]()

    convenience init(bpm: Int) {
        self.init()
        self.BPM = bpm
        initialisePadGrid()
    }

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

    func setBPM(bpm: Int) {
        self.BPM = bpm
    }

    //Initalises the list, as that is what is saved. The pads matrix is not saved.
    func prepareForSave(sessionName: String) {
        padList = List<Pad>()
        self.sessionName = sessionName
        for page in 0..<numPages {
            for row in 0..<numRows {
                for col in 0..<numCols {
                    let pad = pads[page][row][col]
                    pad.prepareForSave()
                    padList.append(pad)
                }
            }
        }
    }
    //Loads from List into Matrix. Realm guarantees that order of insertion is maintained.
    func load() {
        pads = []
        for page in 0..<numPages {
            pads.append([])
            for row in 0..<numRows {
                pads[page].append([])
                for col in 0..<numCols {
                    let listIndex = (page * numRows * numCols) + (row * numCols) + col
                    let pad = padList[listIndex]
                    pad.load()
                    pads[page][row].append(pad)
                }
            }
        }
    }
}
