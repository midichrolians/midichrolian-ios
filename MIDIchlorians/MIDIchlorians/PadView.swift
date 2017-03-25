//
//  PadView.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 25/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol PadView: class {
    func assign(sample: String)
    func assign(animation: AnimationSequence)
}
