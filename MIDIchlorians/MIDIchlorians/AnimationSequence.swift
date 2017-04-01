//
//  AnimationSequence.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

class AnimationSequence {
    private var animationBitsArray: [[AnimationBit]?]
    private var tickCounter: Int
    var toBeRemoved: Bool
    var name: String?

    init() {
        animationBitsArray = [[AnimationBit]]()
        tickCounter = 0
        toBeRemoved = false
        name = nil
    }

    func addAnimationBit(atTick: Int, animationBit: AnimationBit) {
        if animationBitsArray.count <= atTick {
            for _ in animationBitsArray.count...atTick {
                animationBitsArray.append([AnimationBit]())
            }
        }
        guard var array = animationBitsArray[atTick] else {
            animationBitsArray[atTick] = [animationBit]
            return
        }
        array.append(animationBit)
        animationBitsArray[atTick] = array
    }

    func next() -> [AnimationBit]? {
        if tickCounter >= animationBitsArray.count {
            return nil
        }
        let animationBits = [AnimationBit]()
        guard let array = animationBitsArray[tickCounter] else {
            tickCounter += 1
            return animationBits
        }
        tickCounter += 1
        return array
    }

    func getJSONforAnimationSequence() -> String? {
        var arrayOfStrings = [[String]?]()

        for animationBitArray in self.animationBitsArray {
            var arrayForTick = [String]()
            guard let array = animationBitArray else {
                arrayOfStrings.append(nil)
                continue
            }

            for animationBit in array {
                guard let animationBitString = animationBit.getJSON() else {
                    continue
                }
                arrayForTick.append(animationBitString)
            }
            arrayOfStrings.append(arrayForTick)
        }

        var dictionary = [String: Any]()
        dictionary[Config.animationSequenceArrayKey] = arrayOfStrings
        dictionary[Config.animationSequenceNameKey] = name

        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: JSONSerialization.WritingOptions.prettyPrinted
            ) else {
                return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }

    static func getAnimationSequenceFromJSON(fromJSON: String) -> AnimationSequence? {
        guard let data = fromJSON.data(using: .utf8) else {
            return nil
        }

        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return nil
        }

        guard let array = dictionary[Config.animationSequenceArrayKey] as? [[String]?] else {
            return nil
        }

        guard let name = dictionary[Config.animationSequenceNameKey] as? String else {
            return nil
        }

        let animationSequence = AnimationSequence()
        var animationBitsArrayForSequence = [[AnimationBit]]()

        for stringArray in array {
            var arrayForTick = [AnimationBit]()
            guard let arrayOfStrings = stringArray else {
                animationBitsArrayForSequence.append(arrayForTick)
                continue
            }

            for string in arrayOfStrings {
                guard let animationBit = AnimationBit.getAnimationBitFromJSON(fromJSON: string) else {
                    continue
                }
                arrayForTick.append(animationBit)
            }
            animationBitsArrayForSequence.append(arrayForTick)
        }

        animationSequence.animationBitsArray = animationBitsArrayForSequence
        animationSequence.name = name
        return animationSequence
    }
}
