//
//  AnimationTypes.swift
//  MIDIchlorians
//
//  Created by anands on 10/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class AnimationTypes {

    private static var animationTypes = [String: AnimationSequence]()

    // returns the names of all the animation types including the predefined ones
    static func getAllAnimationTypesNames() -> [String] {
        var arrayOfNames = Array(animationTypes.keys)
        arrayOfNames.append(contentsOf: getPredefinedAnimationTypesNames())
        return arrayOfNames
    }

    private static func getPredefinedAnimationTypesNames() -> [String] {
        return [
            Config.animationTypeSparkName,
            Config.animationTypeSpreadName,
            Config.animationTypeRainbowName
        ]
    }

    static func getAnimationSequenceForAnimationType(animationTypeName: String,
                                                     indexPath: IndexPath) -> AnimationSequence? {
        switch animationTypeName {
        case Config.animationTypeSpreadName:
            return spreadFromCenter()
        case Config.animationTypeSparkName:
            return spark(indexPath: indexPath)
        case Config.animationTypeRainbowName:
            return rainbow(indexPath: indexPath)
        default:
            return animationTypes[animationTypeName]
        }
    }

    static func addNewAnimationType(name: String, animationSequence: AnimationSequence) {
        animationTypes[name] = animationSequence
    }

    static func spark(indexPath: IndexPath) -> AnimationSequence {
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

    static func rainbow(indexPath: IndexPath) -> AnimationSequence {
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

    static func spreadFromCenter() -> AnimationSequence {
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

    private static func addAnimationBitToSequenceFrom(arrayOfTuples: [(Int, Int)], tick: Int,
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

    private static let arrayOfInnerTuples = [
        (2, 3),
        (3, 3),
        (2, 4),
        (3, 4)
    ]
    private static let arrayOfMiddleTuples = [
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
    private static let arrayOfOuterTuples = [
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
