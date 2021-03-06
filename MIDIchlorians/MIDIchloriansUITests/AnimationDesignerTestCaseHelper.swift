//
//  AnimationDesignerTestCaseHelper.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
import Foundation
import Nimble

extension AnimationDesignerTestCase {
    func tapAddAnimation() {
        app.navigationBars[Config.animationTabTitle].buttons[Config.commonSystemAddTitle].tap()
    }

    func selectColour(at index: UInt) {
        app.collectionViews[Config.colourPickerA11yLabel].cells.element(boundBy: index).tap()
    }

    func selectClear() {
        let count = app.collectionViews[Config.colourPickerA11yLabel].cells.count
        selectColour(at: count - 1)
    }

    func timelineFrame(at index: UInt) -> XCUIElement {
        return app.collectionViews[Config.timelineA11yLabel].cells.element(boundBy: index)
    }

    func selectTimelineFrame(at index: UInt) {
        timelineFrame(at: index).tap()
    }

    func gridPad(at index: UInt) -> XCUIElement {
        return app.collectionViews[Config.gridA11yLabel].cells.element(boundBy: 0)
    }

    func tapGridPad() {
        gridPad(at: 0).tap()
    }

    func numberOfAnimations() -> UInt {
        return app.tables[Config.animationTableA11YLabel].cells.count
    }

    func expectSizeOfSelectedFrameToBeBigger(selectedIndex: UInt) {
        let originalSize = timelineFrame(at: selectedIndex + 1).frame.size
        let selectedSize = timelineFrame(at: selectedIndex).frame.size
        expect(selectedSize.width) > originalSize.width
        expect(selectedSize.height) > originalSize.height
    }

    func expectGridPadToNotHaveColour() {
        expect(self.gridPad(at: 0).images[Config.gridCollectionViewCellA11yLabel].exists) == false
    }

    func expectGridPadToHaveColour() {
        expect(self.gridPad(at: 0).images[Config.gridCollectionViewCellA11yLabel].exists) == true
    }

    func tapAbsolute() {
        app.buttons["absolute"].tap()
    }

    func tapSaveAnimation() {
        app.buttons[Config.animationDesignSaveLabel].tap()
    }

    func enterNameForAnimationAndSave() {
        let alert = app.alerts[Config.animationSaveAlertTitle]
        alert.textFields.element.typeText("asdf")
        alert.buttons[Config.animationSaveOkayTitle].tap()
    }

}
