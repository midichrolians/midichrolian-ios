//
//  AnimationBit.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

struct AnimationBit: Equatable {
    var colour: Colour
    var row: Int
    var column: Int

    init(colour: Colour, row: Int, column: Int) {
        self.colour = colour
        self.row = row
        self.column = column
    }

    func getJSON() -> String? {
        var dictionary = [String: Any]()
        dictionary[Config.animationBitColourKey] = colour.getJSON()
        dictionary[Config.animationBitRowKey] = row
        dictionary[Config.animationBitColumnKey] = column
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
        guard let colour = dictionary[Config.animationBitColourKey] as? String else {
            return nil
        }
        guard let row = dictionary[Config.animationBitRowKey] as? Int else {
            return nil
        }
        guard let column = dictionary[Config.animationBitColumnKey] as? Int else {
            return nil
        }
        let animationBit = AnimationBit(colour: Colour(colourName: colour), row: row, column: column)
        return animationBit
    }

    static func == (lhs: AnimationBit, rhs: AnimationBit) -> Bool {
        return lhs.colour == rhs.colour && lhs.row == rhs.row && lhs.column == rhs.column
    }
}
