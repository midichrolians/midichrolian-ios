//
//  AnimatableGrid.swift
//  MIDIchlorians
//
//  Created by anands on 24/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

/// The AnimatableGrid protocol should be conformed to by any View
/// which gets passed to the AnimationEngine
protocol AnimatableGrid {
    func getAnimatablePad(forIndex: IndexPath) -> AnimatablePad?
}
