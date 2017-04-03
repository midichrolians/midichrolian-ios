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
    // control to show table of sessions
    private var sessionSelector =
        UIBarButtonItem(
            title: Config.TopNavSessionTitle,
            style: .plain,
            target: self,
            action: #selector(sessionSelect(sender:)))
    // temporary button to trigger save of session
    var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
    // enter edit mode
    var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEdit))
    var exitButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(onExit))

    override init(frame: CGRect) {
        super.init(frame: frame)

        // set up session selector on the left of navigation bar
        baseNavigationItem.leftBarButtonItems = [sessionSelector, saveButton]

        // set up buttons on the right for entering editing mode
        baseNavigationItem.rightBarButtonItems = [editButton]

        // set navigation item on bar stack
        self.setItems([baseNavigationItem], animated: true)

        // style navigation bar
        self.isTranslucent = false
        self.barTintColor = Config.SecondaryBackgroundColor
        self.tintColor = UIColor.darkGray
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func onExit() {
        modeSwitchDelegate?.enterPlay()
        baseNavigationItem.rightBarButtonItems = [editButton]
    }

    func onEdit() {
        modeSwitchDelegate?.enterEdit()
        baseNavigationItem.rightBarButtonItems = [exitButton]
    }

    // Called when the session selector is tapped
    func sessionSelect(sender: UIBarButtonItem) {
        sessionSelectorDelegate?.sessionSelector(sender: sender)
    }

}
