//
//  AnimatableGrid.swift
//  MIDIchlorians
//
//  Created by anands on 24/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol AnimatableGrid {
    func getAnimatablePad(forIndex: IndexPath) -> AnimatablePad?
}
