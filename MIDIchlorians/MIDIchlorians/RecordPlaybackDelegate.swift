//
//  RecordPlaybackDelegate.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 8/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol RecordPlaybackDelegate: class {
    // used to programatically "tap" a pad
    func playPad(page: Int, indexPath: IndexPath)

}
