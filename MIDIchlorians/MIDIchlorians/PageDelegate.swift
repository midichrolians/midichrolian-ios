//
//  PageDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 6/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol PageDelegate: class {
    var currentPage: Int { get }
    func page(selected: Int)
}
