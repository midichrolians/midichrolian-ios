//
//  PredefinedAnimationSchemes.swift
//  MIDIchlorians
//
//  Created by anands on 10/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class PredefinedAnimationSchemes {
    static func spreadOut(indexPath: IndexPath) -> AnimationSequence {
        let animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(
            atTick: 0,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section, column: indexPath.item)
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
                        colour: UIColor.green,
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
        let arrayOfColours = [
            UIColor.violet,
            UIColor.indigo,
            UIColor.blue,
            UIColor.green,
            UIColor.yellow,
            UIColor.orange,
            UIColor.red
        ]
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
}
