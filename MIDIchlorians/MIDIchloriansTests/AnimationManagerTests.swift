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
    var animationName = "some very unique animation name"

    let firstAnimationBit = AnimationBit(colour: Colour.green, row: 1, column: 1)
    let secondAnimationBit = AnimationBit(colour: Colour.violet, row: 5, column: 4)
    let thirdAnimationBit = AnimationBit(colour: Colour.orange, row: 3, column: 2)

    let animationSequenceString = "{\n  \"name\" : \"some very unique animation name\",\n  \"animationBitsArray\"" +
        " : [\n    [\n      \"{\\n  \\\"column\\\" : 1,\\n  \\\"row\\\" : 1,\\n  \\\"colour\\\" : \\\"" +
        "green\\\"\\n}\"\n    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"" +
        "row\\\" : 5,\\n  \\\"colour\\\" : \\\"violet\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 2," +
        "\\n  \\\"row\\\" : 3,\\n  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n    ]\n  ],\n  \"" +
        "frequencyPerBeat\" : \"8\"\n}"

    let animationTypeString = "{\n  \"name\" : \"some very unique animation name\",\n  \"mode\" : \"absolute\",\n" +
        "  \"anchorColumn" +
        "\" : 0,\n  \"anchorRow\" : 0,\n  \"animationSequence\" : \"{\\n  \\\"name\\\" : \\\"some very unique" +
        " animation name\\\"," +
        "\\n  \\\"animationBitsArray\\\" : [\\n    [\\n      \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 1," +
        "\\\\n  \\\\\\\"row\\\\\\\" : 1,\\\\n  \\\\\\\"colour\\\\\\\" : \\\\\\\"green\\\\\\\"\\\\n}\\\"" +
        "\\n    ],\\n    [\\n\\n    ],\\n    [\\n      \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 4,\\\\n  " +
        "\\\\\\\"row\\\\\\\" : 5,\\\\n  \\\\\\\"colour\\\\\\\" : \\\\\\\"violet\\\\\\\"\\\\n}\\\",\\n" +
        "      \\\"{\\\\n  \\\\\\\"column\\\\\\\" : 2,\\\\n  \\\\\\\"row\\\\\\\" : 3,\\\\n  \\\\\\\"" +
        "colour\\\\\\\" : \\\\\\\"orange\\\\\\\"\\\\n}\\\"\\n    ]\\n  ],\\n  \\\"frequencyPerBeat\\\"" +
        " : \\\"8\\\"\\n}\"\n}"

    let animationSequenceRelativeString = "{\n  \"name\" : \"some very unique animation name\",\n  \"" +
        "animationBitsArray\" : [\n " +
        "   [\n      \"{\\n  \\\"column\\\" : 3,\\n  \\\"row\\\" : 4,\\n  \\\"colour\\\" : \\\"green" +
        "\\\"\\n}\"\n    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 6,\\n  \\\"row\\\"" +
        " : 8,\\n  \\\"colour\\\" : \\\"violet\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"" +
        "row\\\" : 6,\\n  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n    ]\n  ],\n  \"frequencyPerBeat\" : " +
        "\"8\"\n}"

    override func setUp() {
        animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(atTick: 0, animationBit: firstAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: secondAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: thirdAnimationBit)
        animationSequence.name = name
    }

    func testGetAllAnimationTypesNamesBeforeAddingNew() {
        let arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertEqual(
            arrayOfAnimationTypesNames.count,
            DataManager.instance.loadAllAnimationTypes().count
        )
    }

    func testAddNewAnimationType() {
        let canAddAnimationType = AnimationManager.instance.addNewAnimationType(
            name: animationName,
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchor: IndexPath(item: 0, section: 0)
        )

        XCTAssertTrue(canAddAnimationType)

        let arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertTrue(arrayOfAnimationTypesNames.contains(animationName))
    }

    func testAbsoluteAnimationType() {
        _ = AnimationManager.instance.addNewAnimationType(
            name: animationName,
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchor: IndexPath(item: 0, section: 0)
        )
        let animationSequenceFromType = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: animationName,
            indexPath: IndexPath(item: 0, section: 0)
        )

        XCTAssertEqual(animationSequenceFromType?.getJSON(), animationSequenceString)
    }

    func testRelativeAnimationType() {
        _ = AnimationManager.instance.addNewAnimationType(
            name: animationName,
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.relative,
            anchor: IndexPath(item: 0, section: 0)
        )
        let animationSequenceFromType = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: animationName,
            indexPath: IndexPath(item: 2, section: 3)
        )

        XCTAssertEqual(animationSequenceFromType?.getJSON(), animationSequenceRelativeString)
    }
}
