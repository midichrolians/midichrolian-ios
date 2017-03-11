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

    init() {
        animationBitsArray = [[AnimationBit]]()
        tickCounter = 0
        toBeRemoved = false
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
}
