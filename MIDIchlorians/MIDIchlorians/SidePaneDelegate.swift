//
//  SidePaneDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 31/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Be notified when the side pane displays different tabs
protocol SidePaneDelegate: class {
    // Called when the side pane has displayed the animation tab
    func sidePaneSelectAnimation()
    // Called when the side pane has displayed the sample tab
    func sidePaneSelectSample()
}

// Default implementations so classes can implement only functions they are interested in
extension SidePaneDelegate {
    func sidePaneSelectAnimation() {}
    func sidePaneSelectSample() {}
}
