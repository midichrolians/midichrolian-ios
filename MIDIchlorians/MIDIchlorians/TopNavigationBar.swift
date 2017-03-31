//
//  TopNavigationBar.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 20/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Navigation bar shown at the top of the app.
// Contains controls to show table of sessions, and switch between modes
class TopNavigationBar: UINavigationBar {
    // delegate that will be notified when the mode switches
    weak var modeSwitchDelegate: ModeSwitchDelegate?
    weak var sessionSelectorDelegate: SessionSelectorDelegate?

    // UI controls in nav bar
    // always only have 1 UINavigationItem because we are not using this in a navigation controller
    private var baseNavigationItem = UINavigationItem(title: Config.TopNavTitle)
    // control to switch between modes
    private var modeSegmentedControl = UISegmentedControl(items: Config.ModeSegmentTitles)
    // control to show table of sessions
    private var sessionSelector =
        UIBarButtonItem(
            title: Config.TopNavSessionTitle,
            style: .plain,
            target: self,
            action: #selector(sessionSelect(sender:)))
    // temporary button to trigger save of session
    var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)

        // set up session selector on the left of navigation bar
        baseNavigationItem.leftBarButtonItems = [sessionSelector, saveButton]

        // set up segmented control for mode selection
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.addTarget(self, action: #selector(onModeChange), for: .valueChanged)
        modeSegmentedControl.tintColor = Config.FontPrimaryColor

        // set segmented control on right of navigation bar
        baseNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: modeSegmentedControl)

        // set navigation item on bar stack
        self.setItems([baseNavigationItem], animated: true)

        // style navigation bar
        self.barStyle = .black
        self.isTranslucent = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Called when mode is changed via interaction with mode segmented control
    func onModeChange() {
        if self.modeSegmentedControl.selectedSegmentIndex == 0 {
            modeSwitchDelegate?.enterPlay()
        } else {
            modeSwitchDelegate?.enterEdit()
        }
    }

    // Called when the session selector is tapped
    func sessionSelect(sender: UIBarButtonItem) {
        sessionSelectorDelegate?.sessionSelector(sender: sender)
    }

}
