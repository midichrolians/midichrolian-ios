//
//  AnimationSequence.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

/// AnimationSequence represents an entire animation which is to be played when a pad is pressed
/// The animation is defined tick-by-tick, where each tick is represented by an
/// array of AnimationBits.

/// It conforms to the IteratorProtocol since it returns the array of AnimationBits
/// for the next tick

class AnimationSequence: JSONable, IteratorProtocol {
    private(set) var animationBitsArray: [[AnimationBit]?]
    private var tickCounter: Int
    var toBeRemoved: Bool
    var name: String?

    // represents how many ticks the AnimationSequence progresses through in one beat
    // BeatFrequency.one means each tick of animation will last an entire beat
    // BeatFrequency.two means each tick of animation will last half the duration of a beat
    // This allows different animations to progress at different speeds
    var frequencyPerBeat: BeatFrequency = BeatFrequency.eight
    private var frameCount: Int

    convenience init(beatFrequency: BeatFrequency) {
        self.init()
        frequencyPerBeat = beatFrequency
    }

    init() {
        animationBitsArray = [[AnimationBit]]()
        tickCounter = 0
        toBeRemoved = false
        name = nil
        frameCount = 0
    }

    convenience required init?(fromJSON: String) {
        guard let data = fromJSON.data(using: .utf8) else {
            return nil
        }

        guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any?] else {
            return nil
        }
        guard let array = dictionary[Config.animationSequenceArrayKey] as? [[String]?] else {
            return nil
        }
        guard let name = dictionary[Config.animationSequenceNameKey] as? String else {
            return nil
        }
        guard let frequencyPerBeat = dictionary[Config.animationSequenceFrequencyKey] as? String else {
            return nil
        }

        self.init()
        var animationBitsArrayForSequence = [[AnimationBit]]()

        for stringArray in array {
            var arrayForTick = [AnimationBit]()
            guard let arrayOfStrings = stringArray else {
                animationBitsArrayForSequence.append(arrayForTick)
                continue
            }

            for string in arrayOfStrings {
                guard let animationBit = AnimationBit(fromJSON: string) else {
                    continue
                }
                arrayForTick.append(animationBit)
            }
            animationBitsArrayForSequence.append(arrayForTick)
        }

        self.animationBitsArray = animationBitsArrayForSequence
        self.name = name
        self.frequencyPerBeat = BeatFrequency(name: frequencyPerBeat)
    }

    // adds an AnimationBit to the frame at a particular tick
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

    // removes a particular AnimationBit from the frame at a particular tick
    func removeAnimationBit(atTick: Int, animationBit: AnimationBit) {
        guard var animationBits = animationBitsArray[atTick] else {
            return
        }
        guard let indexOfAnimationBit = animationBits.index(of: animationBit) else {
            return
        }
        animationBits.remove(at: indexOfAnimationBit)
        animationBitsArray[atTick] = animationBits
    }

    // returns the array of AnimationBits at the next tick, or nil, if the sequence is over
    func next() -> [AnimationBit]? {
        if tickCounter >= animationBitsArray.count {
            tickCounter = 0
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

    // returns the next frame as required by the AnimationEngine.
    // This method exists because one tick in an AnimationSequence need not correspond
    // to one frame as rendered by the AnimationEngine. One tick could correspond to one frame,
    // two frames, four frames and so on, depending on the frequency per beat
    func nextFrame() -> [AnimationBit]? {
        if tickCounter >= animationBitsArray.count {
            tickCounter = 0
            return nil
        }
        let animationBits = [AnimationBit]()
        if frameCount % frequencyPerBeat.framesInABeat() == 0 {
            tickCounter += 1
        }
        frameCount += 1
        guard let array = animationBitsArray[tickCounter - 1] else {
            return animationBits
        }
        return array
    }

    func getJSON() -> String? {
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

        var dictionary = [String: Any?]()
        dictionary[Config.animationSequenceArrayKey] = arrayOfStrings
        dictionary[Config.animationSequenceNameKey] = name
        dictionary[Config.animationSequenceFrequencyKey] = frequencyPerBeat.getJSON()

        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: JSONSerialization.WritingOptions.prettyPrinted
            ) else {
                return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }

}
