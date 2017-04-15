//
//  AnimationManager.swift
//  MIDIchlorians
//
//  Created by anands on 27/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

/// AnimationManager exposes a singleton used by UI to create, edit or
/// delete AnimationTypes, generate AnimationSequences from AnimationTypes

/// It references the DataManager to ensure the persistence of AnimationTypes

class AnimationManager {
    // the singleton
    static var instance = AnimationManager()

    private var animationTypes = [String: AnimationType]()

    private init() {}

    func getAllAnimationTypesNames() -> [String] {
        let storedAnimationTypes = DataManager.instance.loadAllAnimationTypes()
        storedAnimationTypes.forEach({(animationTypeString: String) in
            guard let animationType = AnimationType(fromJSON: animationTypeString) else {
                return
            }
            animationTypes[animationType.name] = animationType
        })
        let arrayOfNames = Array(animationTypes.keys)
        return arrayOfNames
    }

    // returns the AnimationSequence of the given AnimationType for a
    // given origin indexPath (relevant for relative AnimationTypes) and
    // a particular beatFrequency
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

    // creates a new AnimationType and persists it using DataManager
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
        guard let animationString = animationType.getJSON() else {
            return false
        }
        return DataManager.instance.saveAnimation(animationString)
    }

    // deletes the AnimationType from persistence
    func removeAnimationType(name: String) -> Bool {
        guard let animationType = animationTypes[name] else {
            return false
        }
        guard let animationTypeString = animationType.getJSON() else {
            return false
        }
        animationTypes[name] = nil
        return DataManager.instance.removeAnimation(animationTypeString)
    }

    // renames a particular AnimationType
    func editAnimationTypeName(oldName: String, newName: String) -> Bool {
        guard let animationType = animationTypes[oldName] else {
            return false
        }
        if removeAnimationType(name: oldName) == false {
            return false
        }
        return addNewAnimationType(
            name: newName,
            animationSequence: animationType.animationSequence,
            mode: animationType.mode,
            anchor: animationType.anchorPoint
        )
    }

    // returns the AnimationSequence for an AnimationType relative to the index of the
    // pad which was clicked
    private func derelativiseAnimationSequence(animationType: AnimationType,
                                               clickedIndex: IndexPath) -> AnimationSequence {
        let anchor = animationType.anchorPoint
        return transformAnimationSequence(
            animationSequence: animationType.animationSequence,
            rowOffset: clickedIndex.section - anchor.section,
            columnOffset: clickedIndex.item - anchor.item
        )
    }

    // translates each AnimationBit in the AnimationSequence by a given offset
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
