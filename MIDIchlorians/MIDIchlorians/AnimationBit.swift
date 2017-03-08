//
//  AnimationBit.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

struct AnimationBit {
    var colour: UIColor
    var row: Int
    var column: Int

    init(colour: UIColor, row: Int, column: Int) {
        self.colour = colour
        self.row = row
        self.column = column
    }
}
