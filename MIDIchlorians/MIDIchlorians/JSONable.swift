//
//  File.swift
//  MIDIchlorians
//
//  Created by anands on 14/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

/// The JSONable protocol should be conformed to by any type which 
/// can be converted into a JSON string or initialized from a JSON string
protocol JSONable {
    init?(fromJSON: String)
    func getJSON() -> String?
}
