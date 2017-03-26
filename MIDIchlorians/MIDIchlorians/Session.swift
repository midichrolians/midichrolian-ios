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

    private dynamic var BPM = Config.defaultBPM
    private dynamic var numPages = Config.numberOfPages
    private dynamic var numRows = Config.numberOfRows
    private dynamic var numCols = Config.numberOfColumns
    private dynamic var sessionName: String?
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

    func getSessionName() -> String? {
        return sessionName
    }
    
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

    func getPad(page: Int, row: Int, col: Int) -> Pad? {
        guard isValidPosition(page, row, col) else {
            return nil
        }
        return pads[page][row][col]
    }

    //Initalises the list, as that is what is saved. The pads matrix is not saved.
    func prepareForSave(sessionName: String) {
        padList = List<Pad>()
        self.sessionName = sessionName
        for page in 0..<numPages {
            for row in 0..<numRows {
                for col in 0..<numCols {
                    let pad = pads[page][row][col]
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
                    pads[page][row].append(pad)
                }
            }
        }
    }
}
