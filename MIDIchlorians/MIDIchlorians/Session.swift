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
 of pads. A session also has a BPM associated with it, which defines the rate at which any animation
 tied to a pad on the session changes.
 
 A session is represented internally by a 3D matrix of pads. It also has a List<Pad> property,
 which is what is persisted, since Realm cannot persist arrays. Before saving, one needs to call the 
 prepareForSave function, which constructs the list from the matrix. Similarly, one needs to call
 prepareForLoad just after loading a session

 Though a default initialiser is valid(because of Realm), it will lead to incorrect results.
 For correct results, use the convenience initialisers defined below.
 **/
class Session: Object {

    private dynamic var BPM = Config.defaultBPM
    private(set) dynamic var numPages = Config.numberOfPages
    private dynamic var numRows = Config.numberOfRows
    private dynamic var numCols = Config.numberOfColumns
    private dynamic var sessionName: String?
    //Realm wrapper for lazy lists
    private var padList = List<Pad>()

    private var pads = [[[Pad]]]()

    convenience init(bpm: Int) {
        self.init()
        self.BPM = bpm
        initialisePadGrids()
    }

    // An initialiser to create a session which is a copy of another one
    convenience init(session: Session) {
        self.init()
        self.BPM = session.BPM
        self.numPages = session.numPages
        self.numRows = session.numRows
        self.numCols = session.numCols
        self.sessionName = session.sessionName
        //Copy each pad
        for page in 0..<numPages {
            pads.append([])
            for row in 0..<numRows {
                pads[page].append([])
                for col in 0..<numCols {
                    if let pad = session.getPad(page: page, row: row, col: col) {
                        pads[page][row].append(Pad(pad))
                    } else {
                        pads[page][row].append(Pad())
                    }
                }

            }
        }
    }

    //Initialise from JSON
    convenience init?(json: String) {
        self.init()
        guard let data = json.data(using: .utf8) else {
            return nil
        }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: []))
            as? [String: Any?] else {
            return nil
        }
        guard let BPM = dictionary["BPM"] as? Int,
        let numRows = dictionary["numRows"] as? Int,
        let numCols = dictionary["numCols"] as? Int,
        let numPages = dictionary["numPages"] as? Int else {
            return nil
        }

        self.BPM = BPM
        self.numRows = numRows
        self.numCols = numCols
        self.numPages = numPages
        self.sessionName = dictionary["sessionName"] as? String

        guard let padArray = dictionary["pads"] as? [String] else {
            return nil
        }

        // Create pads
        for page in 0..<numPages {
            pads.append([])
            for row in 0..<numRows {
                pads[page].append([])
                for col in 0..<numCols {
                    let listIndex = (page * numRows * numCols) + (row * numCols) + col
                    guard let pad = Pad(json: padArray[listIndex]) else {
                        return nil
                    }
                    pads[page][row].append(pad)
                }
            }
        }

    }

    // Tells Realm that this property is the primary key in the database
    // No 2 sessions can have the same name
    override static func primaryKey() -> String? {
        return "sessionName"
    }

    //Tells Realm that these properties should not be persisted
    override static func ignoredProperties() -> [String] {
        return ["pads"]
    }

    // Create an empty session
    private func initialisePadGrids() {
        for page in 0..<numPages {
            pads.append([])
            for row in 0..<numRows {
                pads[page].append([])
                for _ in 0..<numCols {
                    pads[page][row].append(Pad())
                }

            }
        }
    }

    func setSessionName(sessionName: String) {
        self.sessionName = sessionName
    }

    func getSessionName() -> String? {
        return sessionName
    }

    func getGrid(page: Int) -> [[Pad]] {
        return self.pads[page]
    }

    func getPad(page: Int, indexPath: IndexPath) -> Pad {
        return self.pads[page][indexPath.section][indexPath.row]
    }

    func addBPMToPad(page: Int, row: Int, col: Int, bpm: Int) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].setBPM(bpm: bpm)
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

    func clearBPMAtPad(page: Int, row: Int, col: Int) {
        guard isValidPosition(page, row, col) else {
            return
        }
        pads[page][row][col].clearBPM()
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

    func setSessionBPM(bpm: Int) {
        self.BPM = bpm
        // Sets the bpm for every pad in the session, ensuring that every pad
        // has a BPM = session BPM. If we want pads to support their own
        // bpms, no need to do this
        for page in 0..<numPages {
            for row in 0..<numRows {
                for col in 0..<numCols {
                    guard pads[page][row][col].getBPM() != nil else {
                        continue
                    }
                    pads[page][row][col].setBPM(bpm: bpm)
                }

            }
        }
    }

    func getSessionBPM() -> Int {
        return self.BPM
    }

    func getPad(page: Int, row: Int, col: Int) -> Pad? {
        guard isValidPosition(page, row, col) else {
            return nil
        }
        return pads[page][row][col]
    }

    // Initalises the list, as that is what is persisted. The pads matrix is not saved.
    // This also sets the session name to the value provided
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
    func prepareForUse() {
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

    func getPadList() -> List<Pad> {
        return padList
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let session = object as? Session else {
            return false
        }

        guard self.BPM == session.BPM && self.numPages == session.numPages &&
            self.numRows == session.numRows && self.numCols == session.numCols else {
                return false
        }

        // Check if every pair of pads is equal
        for page in 0..<numPages {
            for row in 0..<numRows {
                for col in 0..<numCols {
                    if pads[page][row][col] != session.pads[page][row][col] {
                        return false
                    }
                }
            }
        }

        return true
    }

    //Convert to JSON String
    func toJSON() -> String? {
        var dictionary = [String: Any?]()
        dictionary["BPM"] = self.BPM
        dictionary["numPages"] = self.numPages
        dictionary["numRows"] = self.numRows
        dictionary["numCols"] = self.numCols
        dictionary["sessionName"] = self.sessionName
        var padArray = [String]()
        for page in 0..<numPages {
            for row in 0..<numRows {
                for col in 0..<numCols {
                    let pad = pads[page][row][col]
                    guard let padJSON = pad.toJSON() else {
                        return nil
                    }
                    padArray.append(padJSON)
                }
            }
        }
        dictionary["pads"] = padArray
        guard let json = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        return String(data: json, encoding: .utf8)
    }
}
