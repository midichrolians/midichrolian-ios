//
//  AnimationBit.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

struct AnimationBit {
    var colour: Colour
    var row: Int
    var column: Int

    static private let colourKey = "colour"
    static private let rowKey = "row"
    static private let columnKey = "column"

    init(colour: Colour, row: Int, column: Int) {
        self.colour = colour
        self.row = row
        self.column = column
    }

    func getJSON() -> String? {
        var dictionary = [String: Any]()
        dictionary[AnimationBit.colourKey] = colour.getJSON()
        dictionary[AnimationBit.rowKey] = row
        dictionary[AnimationBit.columnKey] = column
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: JSONSerialization.WritingOptions.prettyPrinted
            ) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    static func getAnimationBitFromJSON(fromJSON: String) -> AnimationBit? {
        guard let data = fromJSON.data(using: .utf8) else {
            return nil
        }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return nil
        }
        guard let colour = dictionary[colourKey] as? String else {
            return nil
        }
        guard let row = dictionary[rowKey] as? Int else {
            return nil
        }
        guard let column = dictionary[columnKey] as? Int else {
            return nil
        }
        let animationBit = AnimationBit(colour: Colour(colourName: colour), row: row, column: column)
        return animationBit
    }
}
