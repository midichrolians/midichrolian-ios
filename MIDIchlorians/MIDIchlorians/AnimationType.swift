//
//  AnimationTypes.swift
//  MIDIchlorians
//
//  Created by anands on 10/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class AnimationType {
    var name: String
    var mode: AnimationTypeCreationMode
    var animationSequence: AnimationSequence

    init(name: String, animationSequence: AnimationSequence, mode: AnimationTypeCreationMode) {
        self.name = name
        self.mode = mode
        self.animationSequence = animationSequence
    }

    func getJSONforAnimationType() -> String? {
        var dictionary = [String: Any]()
        dictionary[Config.animationTypeNameKey] = name
        dictionary[Config.animationTypeModeKey] = mode
        dictionary[Config.animationTypeAnimationSequenceKey] = animationSequence.getJSONforAnimationSequence()

        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: JSONSerialization.WritingOptions.prettyPrinted
            ) else {
                return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    static func getAnimationTypeFromJSON(fromJSON: String) -> AnimationType? {
        guard let data = fromJSON.data(using: .utf8) else {
            return nil
        }
        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return nil
        }
        guard let name = dictionary[Config.animationTypeNameKey] as? String else {
            return nil
        }
        guard let mode = dictionary[Config.animationTypeModeKey] as? AnimationTypeCreationMode else {
            return nil
        }
        guard let animationSequence = dictionary[Config.animationTypeAnimationSequenceKey] as? AnimationSequence else {
            return nil
        }
        let animationType = AnimationType(name: name, animationSequence: animationSequence, mode: mode)
        return animationType
    }
}
