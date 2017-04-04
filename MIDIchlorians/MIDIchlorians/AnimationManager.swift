//
//  AnimationManager.swift
//  MIDIchlorians
//
//  Created by anands on 27/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

class AnimationManager {
    static var instance = AnimationManager()

    private var animationTypes = [String: AnimationType]()

    func getAllAnimationTypesNames() -> [String] {
        let storedAnimationTypes = DataManager.instance.loadAllAnimationTypes()
        storedAnimationTypes.forEach({(animationTypeString: String) in
            guard let animationType = AnimationType.getAnimationTypeFromJSON(fromJSON: animationTypeString) else {
                return
            }
            animationTypes[animationType.name] = animationType
        })
        var arrayOfNames = Array(animationTypes.keys)
        arrayOfNames.append(contentsOf: getPredefinedAnimationTypesNames())
        return arrayOfNames
    }

    private func getPredefinedAnimationTypesNames() -> [String] {
        return [
            Config.animationTypeSparkName,
            Config.animationTypeSpreadName,
            Config.animationTypeRainbowName
        ]
    }

    func getAnimationSequenceForAnimationType(animationTypeName: String,
                                              beatFrequency: BeatFrequency = BeatFrequency.eight,
                                              indexPath: IndexPath) -> AnimationSequence? {
        var animationSequence = AnimationSequence()

        switch animationTypeName {
        case Config.animationTypeSpreadName:
            animationSequence = spreadFromCenter()
        case Config.animationTypeSparkName:
            animationSequence = spark(indexPath: indexPath)
        case Config.animationTypeRainbowName:
            animationSequence = rainbow(indexPath: indexPath)
        default:
            guard let animationType = animationTypes[animationTypeName] else {
                return nil
            }
            if animationType.mode == .relative {
                animationSequence = derelativiseAnimationSequence(
                    animationSequence: animationType.animationSequence,
                    clickedIndex: indexPath
                )
            } else {
                animationSequence = animationType.animationSequence
            }
        }
        animationSequence.name = animationTypeName
        animationSequence.frequencyPerBeat = beatFrequency
        return animationSequence
    }

    func addNewAnimationType(name: String, animationSequence: AnimationSequence,
                             mode: AnimationTypeCreationMode, anchor: IndexPath) -> Bool {
        var animationType: AnimationType
        if mode == .relative {
            animationType = AnimationType(
                name: name,
                animationSequence: relativiseAnimationSequence(animationSequence: animationSequence, anchor: anchor),
                mode: mode
            )
        } else {
            animationType = AnimationType(
                name: name,
                animationSequence: animationSequence,
                mode: mode
            )
        }
        animationTypes[name] = animationType
        guard let animationString = animationType.getJSONforAnimationType() else {
            return false
        }
        return DataManager.instance.saveAnimation(animationString)
    }

    private func relativiseAnimationSequence(animationSequence: AnimationSequence,
                                             anchor: IndexPath) -> AnimationSequence {

        return transformAnimationSequence(
            animationSequence: animationSequence,
            rowOffset: -anchor.section,
            columnOffset: -anchor.item
        )
    }

    private func derelativiseAnimationSequence(animationSequence: AnimationSequence,
                                               clickedIndex: IndexPath) -> AnimationSequence {

        return transformAnimationSequence(
            animationSequence: animationSequence,
            rowOffset: clickedIndex.section,
            columnOffset: clickedIndex.item
        )
    }

    private func transformAnimationSequence(animationSequence: AnimationSequence,
                                            rowOffset: Int, columnOffset: Int) -> AnimationSequence {
        let transformedAnimationSequence = AnimationSequence()
        var tickCount = 0

        while let animationBits = animationSequence.next() {
            let transformedAnimationBits = animationBits.map({(animationBit: AnimationBit) -> AnimationBit in
                return AnimationBit(
                    colour: animationBit.colour,
                    row: animationBit.row + rowOffset,
                    column: animationBit.column + columnOffset
                )
            })
            for animationBit in transformedAnimationBits {
                transformedAnimationSequence.addAnimationBit(atTick: tickCount, animationBit: animationBit)
            }
            tickCount += 1
        }
        return transformedAnimationSequence
    }

    private func spark(indexPath: IndexPath) -> AnimationSequence {
        let animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(
            atTick: 0,
            animationBit: AnimationBit(colour: Colour.green, row: indexPath.section, column: indexPath.item)
        )
        let indexDifferenceArray = [1, 2]
        for indexDifference in indexDifferenceArray {
            let arrayOfTuples = [
                (indexDifference, 0),
                (-indexDifference, 0),
                (0, indexDifference),
                (0, -indexDifference)
            ]
            for tuple in arrayOfTuples {
                let animationRowNumber = indexPath.section + tuple.0
                let animationColumnNumber = indexPath.item + tuple.1
                if animationRowNumber >= Config.numberOfRows
                    || animationRowNumber < 0
                    || animationColumnNumber >= Config.numberOfColumns
                    || animationColumnNumber < 0 {
                    continue
                }
                animationSequence.addAnimationBit(
                    atTick: indexDifference,
                    animationBit: AnimationBit(
                        colour: Colour.green,
                        row: animationRowNumber,
                        column: animationColumnNumber
                    )
                )
            }
        }
        return animationSequence
    }

    private func rainbow(indexPath: IndexPath) -> AnimationSequence {
        let animationSequence = AnimationSequence()
        let arrayOfColours = Colour.allColours
        for count in 0..<arrayOfColours.count {
            let animationRowNumber = (indexPath.section + count) % Config.numberOfRows
            animationSequence.addAnimationBit(
                atTick: count,
                animationBit: AnimationBit(
                    colour: arrayOfColours[count],
                    row: animationRowNumber,
                    column: indexPath.item
                )
            )
        }
        return animationSequence
    }

    private func spreadFromCenter() -> AnimationSequence {
        let animationSequence = AnimationSequence()

        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfInnerTuples, tick: 0,
                                      colour: Colour.red, animationSequence: animationSequence)
        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfMiddleTuples, tick: 0,
                                      colour: Colour.yellow, animationSequence: animationSequence)
        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfOuterTuples, tick: 0,
                                      colour: Colour.green, animationSequence: animationSequence)

        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfInnerTuples + arrayOfMiddleTuples, tick: 1,
                                      colour: Colour.red, animationSequence: animationSequence)
        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfOuterTuples, tick: 1,
                                      colour: Colour.yellow, animationSequence: animationSequence)

        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfInnerTuples + arrayOfMiddleTuples + arrayOfOuterTuples,
                                      tick: 2, colour: Colour.red, animationSequence: animationSequence)

        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfInnerTuples + arrayOfMiddleTuples, tick: 3,
                                      colour: Colour.red, animationSequence: animationSequence)
        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfOuterTuples, tick: 3,
                                      colour: Colour.yellow, animationSequence: animationSequence)

        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfInnerTuples, tick: 4,
                                      colour: Colour.red, animationSequence: animationSequence)
        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfMiddleTuples, tick: 4,
                                      colour: Colour.yellow, animationSequence: animationSequence)
        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfOuterTuples, tick: 4,
                                      colour: Colour.green, animationSequence: animationSequence)

        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfInnerTuples, tick: 5,
                                      colour: Colour.yellow, animationSequence: animationSequence)
        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfMiddleTuples + arrayOfOuterTuples, tick: 5,
                                      colour: Colour.green, animationSequence: animationSequence)

        addAnimationBitToSequenceFrom(arrayOfTuples: arrayOfInnerTuples + arrayOfMiddleTuples + arrayOfOuterTuples,
                                      tick: 6, colour: Colour.green, animationSequence: animationSequence)
        return animationSequence
    }

    private func addAnimationBitToSequenceFrom(arrayOfTuples: [(Int, Int)], tick: Int,
                                               colour: Colour, animationSequence: AnimationSequence) {
        for tuple in arrayOfTuples {
            animationSequence.addAnimationBit(
                atTick: tick,
                animationBit: AnimationBit(
                    colour: colour,
                    row: tuple.0,
                    column: tuple.1
                )
            )
        }
    }

    private let arrayOfInnerTuples = [
        (2, 3),
        (3, 3),
        (2, 4),
        (3, 4)
    ]
    private let arrayOfMiddleTuples = [
        (1, 2),
        (1, 3),
        (1, 4),
        (1, 5),
        (2, 2),
        (2, 5),
        (3, 2),
        (3, 5),
        (4, 2),
        (4, 3),
        (4, 4),
        (4, 5)
    ]
    private let arrayOfOuterTuples = [
        (0, 0),
        (0, 1),
        (0, 2),
        (0, 3),
        (0, 4),
        (0, 5),
        (0, 6),
        (0, 7),
        (1, 0),
        (1, 1),
        (1, 6),
        (1, 7),
        (2, 0),
        (2, 1),
        (2, 6),
        (2, 7),
        (3, 0),
        (3, 1),
        (3, 6),
        (3, 7),
        (4, 0),
        (4, 1),
        (4, 6),
        (4, 7),
        (0, 0),
        (5, 0),
        (5, 1),
        (5, 2),
        (5, 3),
        (5, 4),
        (5, 5),
        (5, 6),
        (5, 7)
    ]
}
