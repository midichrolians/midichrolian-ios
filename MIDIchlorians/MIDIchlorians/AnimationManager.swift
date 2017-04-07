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
        let arrayOfNames = Array(animationTypes.keys)
        return arrayOfNames
    }

    func getAnimationSequenceForAnimationType(animationTypeName: String,
                                              beatFrequency: BeatFrequency = BeatFrequency.eight,
                                              indexPath: IndexPath) -> AnimationSequence? {
        var animationSequence = AnimationSequence()

        guard let animationType = animationTypes[animationTypeName] else {
            return nil
        }
        if animationType.mode == .relative {
            animationSequence = derelativiseAnimationSequence(
                animationType: animationType,
                clickedIndex: indexPath
            )
        } else {
            animationSequence = animationType.animationSequence
        }

        animationSequence.name = animationTypeName
        animationSequence.frequencyPerBeat = beatFrequency
        return animationSequence
    }

    func addNewAnimationType(name: String, animationSequence: AnimationSequence,
                             mode: AnimationTypeCreationMode, anchor: IndexPath) -> Bool {
        var animationType: AnimationType
        animationType = AnimationType(
            name: name,
            animationSequence: animationSequence,
            mode: mode,
            anchorPoint: anchor
        )
        animationType.animationSequence.name = name
        animationTypes[name] = animationType
        guard let animationString = animationType.getJSONforAnimationType() else {
            return false
        }
        return DataManager.instance.saveAnimation(animationString)
    }

    private func derelativiseAnimationSequence(animationType: AnimationType,
                                               clickedIndex: IndexPath) -> AnimationSequence {
        let anchor = animationType.anchorPoint
        return transformAnimationSequence(
            animationSequence: animationType.animationSequence,
            rowOffset: clickedIndex.section - anchor.section,
            columnOffset: clickedIndex.item - anchor.item
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
}
