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
    var absoluteAnimationName = "some very unique absolute animation name"
    var relativeAnimationName = "some very unique relative animation name"
    var differentAnimationName = "some other very unique animation name"
    var editedDifferentAnimationName = "another very unique animation name"
    var nonExistentAnimationName = "an animation name which does not exist"
    var editedNonExistentAnimationName = "another animation name which does not exist"

    let firstAnimationBit = AnimationBit(colour: Colour.green, row: 1, column: 1)
    let secondAnimationBit = AnimationBit(colour: Colour.violet, row: 5, column: 4)
    let thirdAnimationBit = AnimationBit(colour: Colour.orange, row: 3, column: 2)

    let animationSequenceString = "{\n  \"name\" : \"some very unique absolute animation name\",\n  " +
        "\"animationBitsArray\"" +
        " : [\n    [\n      \"{\\n  \\\"column\\\" : 1,\\n  \\\"row\\\" : 1,\\n  \\\"colour\\\" : \\\"" +
        "green\\\"\\n}\"\n    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"" +
        "row\\\" : 5,\\n  \\\"colour\\\" : \\\"violet\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 2," +
        "\\n  \\\"row\\\" : 3,\\n  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n    ]\n  ],\n  \"" +
        "frequencyPerBeat\" : \"8\"\n}"

    let animationSequenceRelativeString = "{\n  \"name\" : \"some very unique relative animation name\",\n  \"" +
        "animationBitsArray\" : [\n " +
        "   [\n      \"{\\n  \\\"column\\\" : 3,\\n  \\\"row\\\" : 0,\\n  \\\"colour\\\" : \\\"green" +
        "\\\"\\n}\"\n    ],\n    [\n\n    ],\n    [\n      \"{\\n  \\\"column\\\" : 6,\\n  \\\"row\\\"" +
        " : 4,\\n  \\\"colour\\\" : \\\"violet\\\"\\n}\",\n      \"{\\n  \\\"column\\\" : 4,\\n  \\\"" +
        "row\\\" : 2,\\n  \\\"colour\\\" : \\\"orange\\\"\\n}\"\n    ]\n  ],\n  \"frequencyPerBeat\" : " +
        "\"8\"\n}"

    override func setUp() {
        animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(atTick: 0, animationBit: firstAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: secondAnimationBit)
        animationSequence.addAnimationBit(atTick: 2, animationBit: thirdAnimationBit)
        animationSequence.name = name

        _ = AnimationManager.instance.addNewAnimationType(
            name: absoluteAnimationName,
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchor: IndexPath(item: 0, section: 0)
        )

        _ = AnimationManager.instance.addNewAnimationType(
            name: relativeAnimationName,
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.relative,
            anchor: IndexPath(item: 3, section: 5)
        )

    }

    override func tearDown() {
        _ = AnimationManager.instance.removeAnimationType(name: absoluteAnimationName)
        _ = AnimationManager.instance.removeAnimationType(name: relativeAnimationName)
    }

    func testGetAllAnimationTypesNamesBeforeAddingNew() {
        let arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertEqual(
            arrayOfAnimationTypesNames.count,
            DataManager.instance.loadAllAnimationTypes().count
        )
    }

    func testAddAndRemoveNewAnimationType() {
        let canAddAnimationType = AnimationManager.instance.addNewAnimationType(
            name: differentAnimationName,
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchor: IndexPath(item: 0, section: 0)
        )

        XCTAssertTrue(canAddAnimationType)

        var arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertTrue(arrayOfAnimationTypesNames.contains(differentAnimationName))

        let canRemoveAnimationType = AnimationManager.instance.removeAnimationType(name: differentAnimationName)

        XCTAssertTrue(canRemoveAnimationType)

        arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertFalse(arrayOfAnimationTypesNames.contains(differentAnimationName))
    }

    func testAddAndEditNewAnimationType() {
        let canAddAnimationType = AnimationManager.instance.addNewAnimationType(
            name: differentAnimationName,
            animationSequence: animationSequence,
            mode: AnimationTypeCreationMode.absolute,
            anchor: IndexPath(item: 0, section: 0)
        )

        XCTAssertTrue(canAddAnimationType)

        var arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertTrue(arrayOfAnimationTypesNames.contains(differentAnimationName))

        let canEditAnimationType = AnimationManager.instance.editAnimationTypeName(
            oldName: differentAnimationName,
            newName: editedDifferentAnimationName
        )

        XCTAssertTrue(canEditAnimationType)

        arrayOfAnimationTypesNames = AnimationManager.instance.getAllAnimationTypesNames()

        XCTAssertFalse(arrayOfAnimationTypesNames.contains(differentAnimationName))
        XCTAssertTrue(arrayOfAnimationTypesNames.contains(editedDifferentAnimationName))

        _ = AnimationManager.instance.removeAnimationType(name: editedDifferentAnimationName)
    }

    func testRemoveNonExistentAnimationType() {
        let canRemoveAnimationType = AnimationManager.instance.removeAnimationType(name: nonExistentAnimationName)

        XCTAssertFalse(canRemoveAnimationType)
    }

    func testEditNonExistentAnimationType() {
        let canEditAnimationType = AnimationManager.instance.editAnimationTypeName(
            oldName: nonExistentAnimationName,
            newName: editedNonExistentAnimationName
        )
        XCTAssertFalse(canEditAnimationType)
    }

    func testAbsoluteAnimationType() {

        let animationSequenceFromType = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: absoluteAnimationName,
            indexPath: IndexPath(item: 0, section: 0)
        )

        let animationSequenceFromTypeForDifferentIndexPath = AnimationManager
            .instance
            .getAnimationSequenceForAnimationType(
            animationTypeName: absoluteAnimationName,
            indexPath: IndexPath(item: 3, section: 7)
        )

        XCTAssertEqual(animationSequenceFromType?.getJSON(), animationSequenceString)
        XCTAssertEqual(animationSequenceFromTypeForDifferentIndexPath?.getJSON(), animationSequenceString)
    }

    func testRelativeAnimationType() {
        let animationSequenceFromType = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: relativeAnimationName,
            indexPath: IndexPath(item: 5, section: 4)
        )

        XCTAssertEqual(animationSequenceFromType?.getJSON(), animationSequenceRelativeString)
    }

    func testAnimationSequenceOfDifferentBeatFrequency() {
        let animationSequenceFromType = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: relativeAnimationName,
            beatFrequency: BeatFrequency.two,
            indexPath: IndexPath(item: 5, section: 4)
        )

        XCTAssertEqual(animationSequenceFromType?.frequencyPerBeat, BeatFrequency.two)
    }
}
