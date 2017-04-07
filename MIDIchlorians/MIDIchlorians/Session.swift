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
    private(set) dynamic var numPages = Config.numberOfPages
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

    convenience init(session: Session) {
        self.init()
        self.BPM = session.BPM
        self.numPages = session.numPages
        self.numRows = session.numRows
        self.numCols = session.numCols
        self.sessionName = session.sessionName
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

    convenience init?(json: String) {
        self.init()
        guard let data = json.data(using: .utf8) else {
            return nil
        }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any?] else {
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

    override static func primaryKey() -> String? {
        return "sessionName"
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

    func getPad(page: Int, indexPath: IndexPath) -> Pad {
        return self.pads[page][indexPath.section][indexPath.row]
    }

    func getGrid(page: Int) -> [[Pad]] {
        return self.pads[page]
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

    func getPadList() -> List<Pad> {
        return padList
    }

    func equals(_ session: Session) -> Bool {
        guard self.BPM == session.BPM && self.numPages == session.numPages &&
              self.numRows == session.numRows && self.numCols == session.numCols else {
            return false
        }

        for page in 0..<numPages {
            for row in 0..<numRows {
                for col in 0..<numCols {
                    if !pads[page][row][col].equals(session.pads[page][row][col]) {
                        return false
                    }
                }
            }
        }

        return true
    }

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
