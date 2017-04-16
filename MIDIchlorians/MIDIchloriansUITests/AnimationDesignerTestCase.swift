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
