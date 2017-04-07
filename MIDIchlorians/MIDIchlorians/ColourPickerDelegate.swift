//
//  ColourPickerDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol ColourPickerDelegate: class {
    // List of colours the picker should show
    var colours: [Colour] { get }

    // Called when a colour is selected
    func colour(selected: Colour, indexPath: IndexPath)
    // Called when clear selected
    func clear(indexPath: IndexPath)
}
