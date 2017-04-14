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

    // Grid related
    func selectFirstPadInGrid() {
        let grid = app.collectionViews["Grid"]
        let pad1 = grid.cells.element(boundBy: 0)
        pad1.tap()
    }

    func dismissPopover() {
        app.windows.element(boundBy: 0).tap()
    }
}
