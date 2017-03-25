//
//  TopBarController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 23/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

class TopBarController {
    var view: UIView {
        return topNavigationBar as UIView
    }

    private var topNavigationBar = TopNavigationBar()
    weak var modeSwitchDelegate: ModeSwitchDelegate? {
        didSet {
            topNavigationBar.modeSwitchDelegate = modeSwitchDelegate
        }
    }
    weak var sessionSelectorDelegate: SessionSelectorDelegate? {
        didSet {
            topNavigationBar.sessionSelectorDelegate = sessionSelectorDelegate
        }
    }

    func configureWidth(width: CGFloat) {
        topNavigationBar = TopNavigationBar(
            frame: CGRect(origin: CGPoint.zero,
                          size: CGSize(width: width, height: Config.TopNavHeight)))
    }

}
