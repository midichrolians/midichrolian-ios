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

    let animationSequenceString = "{\n  \"name\" : \"name\",\n  \"animationBitsArray\" : [\n  " +
        "  [\n      \"{\\n  \\\"column\\\" : 1,\\n  \\\"row\\\" : 1,\\n  \\\"colour\\\" : \\\"green" +
        "\\\"\\n}\"\n    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"row\\\"" +
        " : 5,\\n  \\\"colour\\\" : \\\"violet\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 2,\\n  " +
    "\\\"row\\\" : 3,\\n  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n    ]\n  ]\n}"

    let animationTypeString = "{\n  \"name\" : \"name\",\n  \"mode\" : \"absolute\",\n  \"animationSequence\"" +
        " : \"{\\n  \\\"name\\\" : \\\"name\\\",\\n  \\\"animationBitsArray\\\" : [\\n    [\\n      \\\"{\\\\n" +
        "  \\\\\\\"column\\\\\\\" : 1,\\\\n  \\\\\\\"row\\\\\\\" : 1,\\\\n  \\\\\\\"colour\\\\\\\" :" +
        " \\\\\\\"green\\\\\\\"\\\\n}\\\"\\n    ],\\n    [\\n\\n    ],\\n    [\\n      \\\"{\\\\n  \\\\\\\"" +
        "column\\\\\\\" : 4,\\\\n  \\\\\\\"row\\\\\\\" : 5,\\\\n  \\\\\\\"colour\\\\\\\" : \\\\\\\"violet\\\\\\\"" +
        "\\\\n}\\\",\\n      \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 2,\\\\n  \\\\\\\"row\\\\\\\" : 3,\\\\n  \\\\\\\"" +
    "colour\\\\\\\" : \\\\\\\"orange\\\\\\\"\\\\n}\\\"\\n    ]\\n  ]\\n}\"\n}"

    let animationSequenceRelativeString = "{\n  \"name\" : \"name\",\n  \"animationBitsArray\" : [\n    [\n" +
        "      \"{\\n  \\\"column\\\" : 3,\\n  \\\"row\\\" : 4,\\n  \\\"colour\\\" : \\\"green\\\"\\n}\"\n" +
        "    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 6,\\n  \\\"row\\\" : 8,\\n  \\\"" +
        "colour\\\" : \\\"violet\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"row\\\" : 6,\\n" +
        "  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n    ]\n  ]\n}"

    override func setUp() {
        animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(atTick: 0, animationBit: firstAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: secondAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: thirdAnimationBit)
        animationSequence.name = "name"
    }

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

    func testAddNewAnimationType() {
        let canAddAnimationType = AnimationManager.instance.addNewAnimationType(
            name: "name",
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchor: IndexPath(item: 0, section: 0)
        )

        XCTAssertTrue(canAddAnimationType)

        let arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertEqual(
            arrayOfAnimationTypesNames,
            [
                "name",
                Config.animationTypeSparkName,
                Config.animationTypeSpreadName,
                Config.animationTypeRainbowName
            ]
        )
    }

    func testAbsoluteAnimationType() {
        _ = AnimationManager.instance.addNewAnimationType(
            name: "name",
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchor: IndexPath(item: 0, section: 0)
        )
        let animationSequenceFromType = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "name",
            indexPath: IndexPath(item: 0, section: 0)
        )

        XCTAssertEqual(animationSequenceFromType?.getJSONforAnimationSequence(), animationSequenceString)
    }

    func testRelativeAnimationType() {
        _ = AnimationManager.instance.addNewAnimationType(
            name: "name",
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.relative,
            anchor: IndexPath(item: 0, section: 0)
        )
        let animationSequenceFromType = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: "name",
            indexPath: IndexPath(item: 2, section: 3)
        )
        print(animationSequenceFromType?.getJSONforAnimationSequence())

        XCTAssertEqual(animationSequenceFromType?.getJSONforAnimationSequence(), animationSequenceRelativeString)
    }

}
