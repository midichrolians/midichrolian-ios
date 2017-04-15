//
//  TopBarTestCase.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 14/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
import Nimble

@testable import MIDIchlorians

class TopBarTestCase: BaseTestCase {
    func expectToBeLoggedOutOfDropbox() {
        let login = app.buttons["Login"]
        expect(login.isEnabled) == true
        expect(self.app.buttons["Logout"].exists) == false
        expect(self.app.buttons["Upload"].isEnabled) == false
        expect(self.app.buttons["Download"].isEnabled) == false
    }

    func assignSampleToPad() {
        let groupTable = app.tables["Group Table"]
        expect(groupTable.cells.count) > 0
        groupTable.cells.element(boundBy: 0).tap()
        let sampleTable = app.tables["Sample Table"]
        sampleTable.cells.element(boundBy: 0).tap()
    }

    func tapRemovePad() {
        app.images["Remove Pad"].tap()
    }

    func ensureRemoveSampleOptionExists() {
        expect(self.app.alerts["Confirm"].buttons["Remove sample"].exists) == true
    }

    func ensureRemoveAnimationOptionExists() {
        expect(self.app.alerts["Confirm"].buttons["Remove sample"].exists) == true
    }

    func ensureRemoveBothOptionExists() {
        ensureRemoveSampleOptionExists()
        ensureRemoveAnimationOptionExists()
        expect(self.app.alerts["Confirm"].buttons["Remove both"].exists) == true
    }

    func tapCancelButton() {
        app.alerts["Confirm"].buttons["Cancel"].tap()
    }

    func assignAnimationToPad() {
        app.tabBars.buttons["Animations"].tap()
        app.tables.staticTexts["Rainbow"].tap()
    }

    func test_editSelected_enableEdit() {
        // enter edit mode
        let edit = tapButton("Edit")
        expectElementToBeSelected(edit)
        _ = tapButton("Sync")
        expectToBeLoggedOutOfDropbox()
        dismissPopover()

        selectFirstPadInGrid()
        assignSampleToPad()

        tapRemovePad()
        ensureRemoveSampleOptionExists()

        tapCancelButton()

        assignAnimationToPad()
        tapRemovePad()
        ensureRemoveAnimationOptionExists()
        ensureRemoveBothOptionExists()
        tapCancelButton()
    }

}
