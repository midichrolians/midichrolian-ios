//
//  AnimationTypes.swift
//  MIDIchlorians
//
//  Created by anands on 10/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class AnimationType: JSONable {
    var name: String
    var mode: AnimationTypeCreationMode
    var animationSequence: AnimationSequence
    var anchorPoint: IndexPath

    init(name: String, animationSequence: AnimationSequence, mode: AnimationTypeCreationMode, anchorPoint: IndexPath) {
        self.name = name
        self.mode = mode
        self.animationSequence = animationSequence
        self.anchorPoint = anchorPoint
    }

    convenience required init?(fromJSON: String) {
        guard let data = fromJSON.data(using: .utf8) else {
            return nil
        }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return nil
        }
        guard let name = dictionary[Config.animationTypeNameKey] as? String else {
            return nil
        }
        guard let modeString = dictionary[Config.animationTypeModeKey] as? String else {
            return nil
        }
        guard let animationSequenceString = dictionary[Config.animationTypeAnimationSequenceKey] as? String else {
            return nil
        }
        guard let mode = AnimationTypeCreationMode(rawValue: modeString) else {
            return nil
        }
        guard let animationSequence = AnimationSequence(
            fromJSON: animationSequenceString) else {
                return nil
        }
        guard let anchorRow = dictionary[Config.animationTypeAnchorRowKey] as? Int else {
            return nil
        }
        guard let anchorColumn = dictionary[Config.animationTypeAnchorColumnKey] as? Int else {
            return nil
        }

        self.init(
            name: name,
            animationSequence: animationSequence,
            mode: mode,
            anchorPoint: IndexPath(item: anchorColumn, section: anchorRow)
        )
    }

    func getJSON() -> String? {
        var dictionary = [String: Any]()
        dictionary[Config.animationTypeNameKey] = name
        dictionary[Config.animationTypeModeKey] = mode.rawValue
        dictionary[Config.animationTypeAnimationSequenceKey] = animationSequence.getJSON()
        dictionary[Config.animationTypeAnchorRowKey] = anchorPoint.section
        dictionary[Config.animationTypeAnchorColumnKey] = anchorPoint.item

        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: JSONSerialization.WritingOptions.prettyPrinted
            ) else {
                return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

}
