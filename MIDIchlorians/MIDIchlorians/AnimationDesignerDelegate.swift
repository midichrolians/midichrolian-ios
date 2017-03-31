//
//  AnimationDesignerDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 30/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

protocol AnimationDesignerDelegate: class {
    func animationTimeline(selected frame: Int)
    func animationColour(selected colour: Colour)
}
