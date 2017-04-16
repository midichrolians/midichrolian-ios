//
//  AnimationDesignerTestCase.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 16/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import XCTest
import Nimble

class AnimationDesignerTestCase: BaseTestCase {

    func tapAddAnimation() {
        app.navigationBars[Config.AnimationTabTitle].buttons[Config.CommonSystemAddTitle].tap()
    }

    func selectColour(at index: UInt) {
        app.collectionViews[Config.ColourPickerA11yLabel].cells.element(boundBy: index).tap()
    }

    func selectClear() {
        let count = app.collectionViews[Config.ColourPickerA11yLabel].cells.count
        selectColour(at: count - 1)
    }

    func timelineFrame(at index: UInt) -> XCUIElement {
        return app.collectionViews[Config.TimelineA11yLabel].cells.element(boundBy: index)
    }

    func selectTimelineFrame(at index: UInt) {
        timelineFrame(at: index).tap()
    }

    func gridPad(at index: UInt) -> XCUIElement {
        return app.collectionViews[Config.GridA11yLabel].cells.element(boundBy: 0)
    }

    func tapGridPad() {
        gridPad(at: 0).tap()
    }

    func numberOfAnimations() -> UInt {
        return app.tables[Config.AnimationTableA11YLabel].cells.count
    }

    func expectSizeOfSelectedFrameToBeBigger(selectedIndex: UInt) {
        let originalSize = timelineFrame(at: selectedIndex + 1).frame.size
        let selectedSize = timelineFrame(at: selectedIndex).frame.size
        expect(selectedSize.width) > originalSize.width
        expect(selectedSize.height) > originalSize.height
    }

    func expectGridPadToNotHaveColour() {
        expect(self.gridPad(at: 0).images[Config.GridCollectionViewCellA11yLabel].exists) == false
    }

    func expectGridPadToHaveColour() {
        expect(self.gridPad(at: 0).images[Config.GridCollectionViewCellA11yLabel].exists) == true
    }

    func tapAbsolute() {
        app.buttons["absolute"].tap()
    }

    func tapSaveAnimation() {
        app.buttons[Config.AnimationDesignSaveLabel].tap()
    }

    func enterNameForAnimationAndSave() {
        let alert = app.alerts[Config.AnimationSaveAlertTitle]
        alert.textFields.element.typeText("asdf")
        alert.buttons[Config.AnimationSaveOkayTitle].tap()
    }

    func test_animationDesigner_newAnimation() {
        enterEditMode()
        selectAnimationsTab()
        let prevCount = numberOfAnimations()
        tapAddAnimation()
        selectColour(at: 0)
        expectSizeOfSelectedFrameToBeBigger(selectedIndex: 0)

        // add a colour to the pad
        expectGridPadToNotHaveColour()
        tapGridPad()
        expectGridPadToHaveColour()

        selectTimelineFrame(at: 1)
        expectSizeOfSelectedFrameToBeBigger(selectedIndex: 1)

        // add a different colour to the pad
        expectGridPadToNotHaveColour()
        selectColour(at: 1)
        tapGridPad()
        expectGridPadToHaveColour()

        // should be clear button
        selectClear()
        tapGridPad()
        expectGridPadToNotHaveColour()

        tapAbsolute()
        tapSaveAnimation()
        enterNameForAnimationAndSave()
        let newCount = numberOfAnimations()
        expect(newCount) == prevCount + 1
    }
    
}
