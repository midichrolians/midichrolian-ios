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
    func test_editSelected_enableEdit() {
        // enter edit mode
        let edit = tapButton(Config.topNavEditLabel)
        expectElementToBeSelected(edit)
        _ = tapButton(Config.topNavSyncLabel)
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

    func test_newSession_createsNewSession() {
        let currentSessionTitle = app.staticTexts[Config.topNavSessionTitleA11yLabel].label
        let prevCount = tapSessionAndGetSessionCount()
        newSession()

        let newSessionTitle = app.staticTexts[Config.topNavSessionTitleA11yLabel].label
        expect(currentSessionTitle == newSessionTitle) == false

        let newCount = tapSessionAndGetSessionCount()
        expect(newCount).to(equal(prevCount + 1))
    }

    func test_editSession_editName() {
        tapSession()
        editRow(app.tables[Config.sessionTableA11yLabel])
        let originalName = getSessionName(0)
        // suffix because the cursor is at the end of the text field
        let suffix = "123"
        typeSessionName(suffix)
        okay(app.alerts.element)
        expectSessionExists("\(originalName)\(suffix)")
    }

    func test_editSession_removeSession() {
        let prevCount = tapSessionAndGetSessionCount()
        let sessionTable = app.tables[Config.sessionTableA11yLabel]
        removeRow(sessionTable)
        confirm(app.alerts.element)
        let newCount = sessionCount()
        expect(newCount).to(equal(prevCount - 1))
    }

}
