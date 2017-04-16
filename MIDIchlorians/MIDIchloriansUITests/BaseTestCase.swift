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
        app.buttons[Config.TopNavExitLabel].tap()
    }

    func selectAnimationsTab() {
        app.tabBars.buttons[Config.AnimationTabTitle].tap()
    }

    // Grid related
    func selectFirstPadInGrid() {
        let grid = app.collectionViews["Grid"]
        let pad1 = grid.cells.element(boundBy: 0)
        pad1.tap()
    }

    func dismissPopover() {
        app.otherElements[Config.PopOverDismissLabel].tap()
    }

    // MARK: - Table view action related

    func editRow(_ table: XCUIElement) {
        table.cells.element(boundBy: 0).swipeLeft()
        table.cells.element(boundBy: 0).buttons[Config.CommonEditActionTitle].tap()
    }

    func removeRow(_ table: XCUIElement) {
        table.cells.element(boundBy: 0).swipeLeft()
        table.cells.element(boundBy: 0).buttons[Config.CommonRemoveActionTitle].tap()
    }

    // MARK: - Alerts related

    func cancel(_ alert: XCUIElement) {
        alert.buttons[Config.CommonButtonCancelTitle].tap()
    }

    func okay(_ alert: XCUIElement) {
        alert.buttons[Config.CommonButtonOkayTitle].tap()
    }

    func confirm(_ alert: XCUIElement) {
        alert.buttons[Config.CommonButtonConfirmTitle].tap()
    }
}
