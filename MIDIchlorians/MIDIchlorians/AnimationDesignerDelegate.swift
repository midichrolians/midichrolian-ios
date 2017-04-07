//
//  AnimationDesignerDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 30/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Conform to this protocol to be notified when animation designer is interacted with.
// The interactions that are supported are, selecting a frame in the timeline,
// and selecting a colour in the palette.
protocol AnimationDesignerDelegate: class {
    // Frame at index frame is selected
    func animationTimeline(selected frame: Int)
    // Colour is selected
    func animationColour(selected colour: Colour)
    // Clear selected
    func animationClear()
    // Animation type creation mode is selected
    func animationTypeCreationMode(selected mode: AnimationTypeCreationMode)
    // Save the animation designed thus far
    func saveAnimation(name: String)
}

// Default no-op implementations
extension AnimationDesignerDelegate {
    func animationTimeline(selected frame: Int) {}
    func animationColour(selected colour: Colour) {}
    func animationTypeCreationMode(selected mode: AnimationTypeCreationMode) {}
    func saveAnimation() {}
}
