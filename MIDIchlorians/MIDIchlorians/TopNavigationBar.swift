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

    // UI controls in nav bar
    // always only have 1 UINavigationItem because we are not using this in a navigation controller
    private var baseNavigationItem = UINavigationItem(title: Config.TopNavTitle)
    // control to switch between modes
    private var modeSegmentControl = UISegmentedControl(items: Config.ModeSegmentTitles)
    // control to show table of sessions
    private var sessionSelector =
        UIBarButtonItem(title: Config.TopNavSessionTitle, style: .plain, target: nil, action: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)

        // set up session selector on the left of navigation bar
        baseNavigationItem.leftBarButtonItem = sessionSelector

        // set up segment control for mode selection
        modeSegmentControl.selectedSegmentIndex = 0
        modeSegmentControl.addTarget(self, action: #selector(onModeChange), for: .valueChanged)
        modeSegmentControl.tintColor = Config.FontPrimaryColor

        // set segment control on right of navigation bar
        baseNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: modeSegmentControl)

        // set navigation item on bar stack
        self.setItems([baseNavigationItem], animated: true)

        // style navigation bar
        self.barStyle = .black
        self.isTranslucent = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Called when mode is changed via interaction with mode segment control
    func onModeChange() {
        if self.modeSegmentControl.selectedSegmentIndex == 0 {
            modeSwitchDelegate?.enterPlay()
        } else {
            modeSwitchDelegate?.enterEdit()
        }
    }

    // Set target and selector to be call when session control has been interacted with
    func addTargetToSessionSelector(_ target: Any?, action selector: Selector) {
        sessionSelector.target = target as AnyObject?
        sessionSelector.action = selector
    }

}
