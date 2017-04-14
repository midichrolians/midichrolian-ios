//
//  SampleSettingDelegate.swift
//  MIDIchlorians
//
//  Created by anands on 10/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Conform to this protocol to be notified when the sample setting changes
protocol SampleSettingDelegate: class {
    // Called when sample setting changes
    func sampleSettingMode(selected: SampleSettingMode)
}
