//
//  AnimationSequenceTests.swift
//  MIDIchlorians
//
//  Created by anands on 31/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class AnimationSequenceTests: XCTestCase {

    var animationSequence = AnimationSequence()

    let firstAnimationBit = AnimationBit(colour: Colour.green, row: 1, column: 1)
    let secondAnimationBit = AnimationBit(colour: Colour.violet, row: 5, column: 4)
    let thirdAnimationBit = AnimationBit(colour: Colour.orange, row: 3, column: 2)

    let animationSequenceString = "{\n  \"name\" : \"name\",\n  \"animationBitsArray\" : [\n" +
    "    [\n      \"{\\n  \\\"column\\\" : 1,\\n  \\\"row\\\" : 1,\\n  \\\"colour\\\" : \\\"" +
    "green\\\"\\n}\"\n    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"" +
    "row\\\" : 5,\\n  \\\"colour\\\" : \\\"violet\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 2," +
    "\\n  \\\"row\\\" : 3,\\n  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n    ]\n  ],\n  \"" +
    "frequencyPerBeat\" : \"8\"\n}"

    override func setUp() {
        animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(atTick: 0, animationBit: firstAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: secondAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: thirdAnimationBit)
        animationSequence.name = "name"
    }

    func testAddAnimationBit() {
        XCTAssertEqual(animationSequence.next()!, [firstAnimationBit])
        XCTAssertEqual(animationSequence.next()!, [AnimationBit]())
        XCTAssertEqual(animationSequence.next()!, [secondAnimationBit, thirdAnimationBit])
        XCTAssertNil(animationSequence.next())
    }

    func testGetJSONforAnimationSequence() {
        let stringFromAnimationSequence = animationSequence.getJSON()
        XCTAssertEqual(
            stringFromAnimationSequence,
            animationSequenceString
        )
    }

    func testGetAnimationSequenceFromJSON() {
        let animationSequenceFromString = AnimationSequence(
            fromJSON: animationSequenceString
        )

        XCTAssertEqual((animationSequenceFromString?.next())!, [firstAnimationBit])
        XCTAssertEqual((animationSequenceFromString?.next())!, [AnimationBit]())
        XCTAssertEqual((animationSequenceFromString?.next())!, [secondAnimationBit, thirdAnimationBit])
        XCTAssertNil(animationSequenceFromString?.next())
    }

    func testGetAnimationSequenceFromInvalidString() {
        let animationSequenceFromString = AnimationSequence(
            fromJSON: "some invalid string"
        )

        XCTAssertNil(animationSequenceFromString)
    }
}
