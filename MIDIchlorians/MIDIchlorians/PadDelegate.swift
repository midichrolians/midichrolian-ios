//
//  PadDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 27/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol PadDelegate: class {
    func padTapped(indexPath: IndexPath)
}
