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
        let login = app.buttons[Config.TopNavLoginTitle]
        expect(login.isEnabled) == true
        expect(self.app.buttons[Config.TopNavLogoutTitle].exists) == false
        expect(self.app.buttons[Config.TopNavSyncUploadTitle].isEnabled) == false
        expect(self.app.buttons[Config.TopNavSyncDownloadTitle].isEnabled) == false
    }

    func assignSampleToPad() {
        let groupTable = app.tables[Config.GroupTableA11yLabel]
        expect(groupTable.cells.count) > 0
        groupTable.cells.element(boundBy: 0).tap()
        let sampleTable = app.tables[Config.SampleTableA11yLabel]
        sampleTable.cells.element(boundBy: 0).tap()
    }

    func tapRemovePad() {
        app.images[Config.RemoveButtonA11yLabel].tap()
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

    func tapSession() {
        app.buttons[Config.TopNavSessionLabel].tap()
    }

    func newSession() {
        app.navigationBars[Config.SessionTableTitle].buttons[Config.CommonSystemAddTitle].tap()
    }

    func sessionCount() -> UInt {
        return app.tables[Config.SessionTableA11yLabel].cells.count
    }

    func tapSessionAndGetSessionCount() -> UInt {
        tapSession()
        return sessionCount()
    }

    func editSessions() {
        app.navigationBars[Config.TopNavSessionLabel].buttons[Config.TopNavEditLabel].tap()
    }

    func expectSessionExists(_ name: String) {
        expect(self.app.tables[Config.SessionTableA11yLabel].cells.staticTexts[name].exists) == true
    }

    func getSessionName(_ index: UInt) -> String {
        return app.tables[Config.SessionTableA11yLabel].cells.element(boundBy: index).staticTexts.element.label
    }

    func typeSessionName(_ suffix: String) {
        app.alerts.element.textFields.element.typeText(suffix)
    }
    
}
