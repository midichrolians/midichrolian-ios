//
//  ColourPickerDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol ColourPickerDelegate: class {
    var colours: [Colour] { get }

    func colour(selected: Colour, indexPath: IndexPath)
}
