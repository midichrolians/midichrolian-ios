//
//  TopBarTestCaseHelpers.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import Nimble

extension TopBarTestCase {
    func expectToBeLoggedOutOfDropbox() {
        let login = app.buttons[Config.topNavLoginTitle]
        expect(login.isEnabled) == true
        expect(self.app.buttons[Config.topNavLogoutTitle].exists) == false
        expect(self.app.buttons[Config.topNavSyncUploadTitle].isEnabled) == false
        expect(self.app.buttons[Config.topNavSyncDownloadTitle].isEnabled) == false
    }

    func assignSampleToPad() {
        let groupTable = app.tables[Config.groupTableA11yLabel]
        expect(groupTable.cells.count) > 0
        groupTable.cells.element(boundBy: 0).tap()
        let sampleTable = app.tables[Config.sampleTableA11yLabel]
        sampleTable.cells.element(boundBy: 0).tap()
    }

    func tapRemovePad() {
        app.images[Config.removeButtonA11yLabel].tap()
    }

    func ensureRemoveSampleOptionExists() {
        expect(self.app.alerts[Config.removeButtonAlertTitle].buttons[Config.removeButtonSampleTitle].exists) == true
    }

    func ensureRemoveAnimationOptionExists() {
        expect(self.app.alerts[Config.removeButtonAlertTitle].buttons[Config.removeButtonSampleTitle].exists) == true
    }

    func ensureRemoveBothOptionExists() {
        ensureRemoveSampleOptionExists()
        ensureRemoveAnimationOptionExists()
        expect(self.app.alerts[Config.removeButtonAlertTitle].buttons[Config.removeButtonBothTitle].exists) == true
    }

    func tapCancelButton() {
        app.alerts[Config.removeButtonAlertTitle].buttons[Config.removeButtonCancelTitle].tap()
    }

    func assignAnimationToPad() {
        app.tabBars.buttons[Config.animationTabTitle].tap()
        app.tables.staticTexts[Config.animationTypeRainbowName].tap()
    }

    func tapSession() {
        app.buttons[Config.topNavSessionLabel].tap()
    }

    func newSession() {
        app.navigationBars[Config.sessionTableTitle].buttons[Config.commonSystemAddTitle].tap()
    }

    func sessionCount() -> UInt {
        return app.tables[Config.sessionTableA11yLabel].cells.count
    }

    func tapSessionAndGetSessionCount() -> UInt {
        tapSession()
        return sessionCount()
    }

    func editSessions() {
        app.navigationBars[Config.topNavSessionLabel].buttons[Config.topNavEditLabel].tap()
    }

    func expectSessionExists(_ name: String) {
        expect(self.app.tables[Config.sessionTableA11yLabel].cells.staticTexts[name].exists) == true
    }

    func getSessionName(_ index: UInt) -> String {
        return app.tables[Config.sessionTableA11yLabel].cells.element(boundBy: index).staticTexts.element.label
    }

    func typeSessionName(_ suffix: String) {
        app.alerts.element.textFields.element.typeText(suffix)
    }
    
}
