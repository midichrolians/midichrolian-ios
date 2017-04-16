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

    func tapSession() {
        app.buttons["Sessions"].tap()
    }

    func newSession() {
        app.buttons["New session"].tap()
    }

    func sessionCount() -> UInt {
        return app.tables["Session Table"].cells.count
    }

    func tapSessionAndGetSessionCount() -> UInt {
        tapSession()
        return sessionCount()
    }

    func test_newSession_createsNewSession() {
        let currentSessionTitle = app.staticTexts["Session title"].label
        let prevCount = tapSessionAndGetSessionCount()
        newSession()

        let newSessionTitle = app.staticTexts["Session title"].label
        expect(currentSessionTitle == newSessionTitle) == false

        let newCount = tapSessionAndGetSessionCount()
        expect(newCount).to(equal(prevCount + 1))
    }

    func editSessions() {
        app.navigationBars["Sessions"].buttons["Edit"].tap()
    }

    func expectSessionExists(_ name: String) {
        expect(self.app.tables["Session Table"].cells.staticTexts[name].exists) == true
    }

    func getSessionName(_ index: UInt) -> String {
        return app.tables["Session Table"].cells.element(boundBy: index).staticTexts.element.label
    }

    func typeSessionName(_ suffix: String) {
        app.alerts.element.textFields.element.typeText(suffix)
    }

    func test_editSession_editName() {
        tapSession()
        editRow(app.tables["Session Table"])
        let originalName = getSessionName(0)
        // suffix because the cursor is at the end of the text field
        let suffix = "123"
        typeSessionName(suffix)
        okay(app.alerts.element)
        expectSessionExists("\(originalName)\(suffix)")
    }

    func test_editSession_removeSession() {
        let prevCount = tapSessionAndGetSessionCount()
        let sessionTable = app.tables["Session Table"]
        removeRow(sessionTable)
        confirm(app.alerts.element)
        let newCount = sessionCount()
        expect(newCount).to(equal(prevCount - 1))
    }

}
