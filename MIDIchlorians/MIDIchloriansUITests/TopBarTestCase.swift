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
        let login = app.buttons[Config.TopNavLoginTitle]
        expect(login.isEnabled) == true
        expect(self.app.buttons[Config.TopNavLogoutTitle].exists) == false
        expect(self.app.buttons[Config.TopNavSyncUploadTitle].isEnabled) == false
        expect(self.app.buttons[Config.TopNavSyncDownloadTitle].isEnabled) == false
    }

    func assignSampleToPad() {
        let groupTable = app.tables["Group Table"]
        expect(groupTable.cells.count) > 0
        groupTable.cells.element(boundBy: 0).tap()
        let sampleTable = app.tables["Sample Table"]
        sampleTable.cells.element(boundBy: 0).tap()
    }

    func tapRemovePad() {
        app.images["Remove pad"].tap()
    }

    func ensureRemoveSampleOptionExists() {
        expect(self.app.alerts[Config.RemoveButtonAlertTitle].buttons[Config.RemoveButtonSampleTitle].exists) == true
    }

    func ensureRemoveAnimationOptionExists() {
        expect(self.app.alerts[Config.RemoveButtonAlertTitle].buttons[Config.RemoveButtonSampleTitle].exists) == true
    }

    func ensureRemoveBothOptionExists() {
        ensureRemoveSampleOptionExists()
        ensureRemoveAnimationOptionExists()
        expect(self.app.alerts[Config.RemoveButtonAlertTitle].buttons[Config.RemoveButtonBothTitle].exists) == true
    }

    func tapCancelButton() {
        app.alerts[Config.RemoveButtonAlertTitle].buttons[Config.RemoveButtonCancelTitle].tap()
    }

    func assignAnimationToPad() {
        app.tabBars.buttons[Config.AnimationTabTitle].tap()
        app.tables.staticTexts[Config.animationTypeRainbowName].tap()
    }

    func test_editSelected_enableEdit() {
        // enter edit mode
        let edit = tapButton(Config.TopNavEditLabel)
        expectElementToBeSelected(edit)
        _ = tapButton(Config.TopNavSyncLabel)
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
        app.buttons[Config.TopNavSessionLabel].tap()
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
        app.navigationBars[Config.TopNavSessionLabel].buttons[Config.TopNavEditLabel].tap()
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
