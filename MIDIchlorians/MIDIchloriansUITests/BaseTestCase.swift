//
//  BaseTestCase.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 14/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
import Nimble

class BaseTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        XCUIDevice.shared().orientation = .landscapeRight
        app = XCUIApplication()
    }

    func tapButton(_ label: String) -> XCUIElement {
        let button = app.buttons[label]
        expect(button.exists) == true
        button.tap()
        return button
    }

    func table(_ label: String) -> XCUIElement {
        let table = app.tables[label]
        expect(table.exists) == true
        return table
    }

    func expectElementToBeSelected(_ element: XCUIElement) {
        expect(element.isSelected) == true
    }

    func enterEditMode() {
        app.buttons[Config.topNavEditLabel].tap()
    }

    func selectAnimationsTab() {
        app.tabBars.buttons[Config.animationTabTitle].tap()
    }

    // MARK: - Grid related
    func selectFirstPadInGrid() {
        let grid = app.collectionViews[Config.gridA11yLabel]
        let pad1 = grid.cells.element(boundBy: 0)
        pad1.tap()
    }

    func dismissPopover() {
        app.otherElements[Config.popOverDismissLabel].tap()
    }

    // MARK: - Table view action related

    func editRow(_ table: XCUIElement) {
        table.cells.element(boundBy: 0).swipeLeft()
        table.cells.element(boundBy: 0).buttons[Config.commonEditActionTitle].tap()
    }

    func removeRow(_ table: XCUIElement) {
        table.cells.element(boundBy: 0).swipeLeft()
        table.cells.element(boundBy: 0).buttons[Config.commonRemoveActionTitle].tap()
    }

    // MARK: - Alerts related

    func cancel(_ alert: XCUIElement) {
        alert.buttons[Config.commonButtonCancelTitle].tap()
    }

    func okay(_ alert: XCUIElement) {
        alert.buttons[Config.commonButtonOkayTitle].tap()
    }

    func confirm(_ alert: XCUIElement) {
        alert.buttons[Config.commonButtonConfirmTitle].tap()
    }
}
