//
//  AnimationBitTests.swift
//  MIDIchlorians
//
//  Created by anands on 30/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
@testable import MIDIchlorians

class AnimationBitTests: XCTestCase {
    func testGetJSON() {
        XCTAssertEqual(
            AnimationBit(colour: Colour.blue, row: 0, column: 0).getJSON(),
            "{\n  \"column\" : 0,\n  \"row\" : 0,\n  \"colour\" : \"blue\"\n}"
        )
    }

    func testGetAnimationBitFromJSON() {
        let animationBit = AnimationBit.getAnimationBitFromJSON(
            fromJSON: "{\n  \"column\" : 0,\n  \"row\" : 0,\n  \"colour\" : \"blue\"\n}"
        )
        XCTAssertEqual(
            animationBit!.colour,
            Colour.blue
        )
        XCTAssertEqual(
            animationBit!.row,
            0
        )
        XCTAssertEqual(
            animationBit!.column,
            0
        )
    }

    func testNilFromInvalidString() {
        let animationBit = AnimationBit.getAnimationBitFromJSON(
            fromJSON: "{\n  \"column\" : 0,\n  \"row\" : 0,\n  \"invalid\" : \"blue\"\n}"
        )
        XCTAssertNil(animationBit)
    }

}
