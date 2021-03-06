//
//  AnimationTypeTests.swift
//  MIDIchlorians
//
//  Created by anands on 31/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class AnimationTypeTests: XCTestCase {

    var animationSequence = AnimationSequence()

    let firstAnimationBit = AnimationBit(colour: Colour.green, row: 1, column: 1)
    let secondAnimationBit = AnimationBit(colour: Colour.purple, row: 5, column: 4)
    let thirdAnimationBit = AnimationBit(colour: Colour.pink, row: 3, column: 2)

    let animationSequenceString = "{\n  \"name\" : \"name\",\n  \"animationBitsArray\" : [\n" +
        "    [\n      \"{\\n  \\\"column\\\" : 1,\\n  \\\"row\\\" : 1,\\n  \\\"colour\\\" : \\\"" +
        "green\\\"\\n}\"\n    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"" +
        "row\\\" : 5,\\n  \\\"colour\\\" : \\\"purple\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 2," +
        "\\n  \\\"row\\\" : 3,\\n  \\\"colour\\\" : \\\"pink\\\"\\n}\"\n    ]\n  ],\n  \"" +
        "frequencyPerBeat\" : \"8\"\n}"

    let animationTypeString = "{\n  \"name\" : \"name\",\n  \"mode\" : \"absolute\",\n  \"anchorColumn" +
        "\" : 0,\n  \"anchorRow\" : 0,\n  \"animationSequence\" : \"{\\n  \\\"name\\\" : \\\"name\\\"," +
        "\\n  \\\"animationBitsArray\\\" : [\\n    [\\n      \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 1," +
        "\\\\n  \\\\\\\"row\\\\\\\" : 1,\\\\n  \\\\\\\"colour\\\\\\\" : \\\\\\\"green\\\\\\\"\\\\n}\\\"" +
        "\\n    ],\\n    [\\n\\n    ],\\n    [\\n      \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 4,\\\\n  " +
        "\\\\\\\"row\\\\\\\" : 5,\\\\n  \\\\\\\"colour\\\\\\\" : \\\\\\\"purple\\\\\\\"\\\\n}\\\",\\n" +
        "      \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 2,\\\\n  \\\\\\\"row\\\\\\\" : 3,\\\\n  \\\\\\\"" +
        "colour\\\\\\\" : \\\\\\\"pink\\\\\\\"\\\\n}\\\"\\n    ]\\n  ],\\n  \\\"frequencyPerBeat\\\"" +
        " : \\\"8\\\"\\n}\"\n}"

    override func setUp() {
        animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(atTick: 0, animationBit: firstAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: secondAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: thirdAnimationBit)
        animationSequence.name = "name"
    }

    func testGetJSONforAnimationType() {
        let animationType = AnimationType(
            name: "name",
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchorPoint: IndexPath(item: 0, section: 0)
        )
        let stringFromAnimationType = animationType.getJSON()

        XCTAssertEqual(stringFromAnimationType, animationTypeString)
    }

    func testGetAnimationTypeFromJSON() {
        let animationType = AnimationType(fromJSON: animationTypeString)

        XCTAssertEqual(animationType?.name, "name")
        XCTAssertEqual(animationType?.mode, AnimationTypeCreationMode.absolute)
        XCTAssertEqual(animationType?.animationSequence.getJSON(), animationSequenceString)
    }

    func testGetAnimationTypeFromInvalidString() {
        let animationType = AnimationType(
            fromJSON: "some invalid string"
        )

        XCTAssertNil(animationType)
    }
}
