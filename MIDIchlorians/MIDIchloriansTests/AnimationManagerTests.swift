//
//  AnimationManagerTests.swift
//  MIDIchlorians
//
//  Created by anands on 31/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class AnimationManagerTests: XCTestCase {

    var animationSequence = AnimationSequence()

    let firstAnimationBit = AnimationBit(colour: Colour.green, row: 1, column: 1)
    let secondAnimationBit = AnimationBit(colour: Colour.violet, row: 5, column: 4)
    let thirdAnimationBit = AnimationBit(colour: Colour.orange, row: 3, column: 2)

    let animationSequenceString = "[\n  [\n    \"{\\n  \\\"column\\\" : 1,\\n  \\\"row\\\" : 1,\\n  \\\"colour\\\" :" +
        " \\\"green\\\"\\n}\"\n  ],\n  [\n\n  ],\n  [\n    \"{\\n  \\\"column\\\" : 4,\\n" +
        "  \\\"row\\\" : 5,\\n  \\\"colour\\\" : \\\"violet\\\"\\n}\",\n    \"{\\n  \\\"column\\\" " +
        ": 2,\\n  \\\"row\\\" : 3,\\n  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n  ]\n]"

    let animationTypeString = "{\n  \"name\" : \"name\",\n  \"mode\" : \"absolute\",\n  \"animationSequence\" " +
        ": \"[\\n  [\\n    \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 1,\\\\n  \\\\\\\"row\\\\\\\" : 1,\\\\n  \\\\\\\"" +
        "colour\\\\\\\" : \\\\\\\"green\\\\\\\"\\\\n}\\\"\\n  ],\\n  [\\n\\n  ],\\n  [\\n    \\\"{\\\\n  \\\\\\\"" +
        "column\\\\\\\" : 4,\\\\n  \\\\\\\"row\\\\\\\" : 5,\\\\n  \\\\\\\"colour\\\\\\\" : \\\\\\\"violet\\\\\\\"" +
        "\\\\n}\\\",\\n    \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 2,\\\\n  \\\\\\\"row\\\\\\\" : 3,\\\\n  \\\\\\\"" +
        "colour\\\\\\\" : \\\\\\\"orange\\\\\\\"\\\\n}\\\"\\n  ]\\n]\"\n}"

    func testGetAllAnimationTypesNamesBeforeAddingNew() {
        let arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertEqual(
            arrayOfAnimationTypesNames,
            [
                Config.animationTypeSparkName,
                Config.animationTypeSpreadName,
                Config.animationTypeRainbowName
            ]
        )
    }
}
