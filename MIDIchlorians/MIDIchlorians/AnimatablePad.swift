//
//  AnimatablePad.swift
//  MIDIchlorians
//
//  Created by anands on 24/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

/// The AnimatablePad protocol should be conformed to any View
/// which the AnimationEngine can animate
protocol AnimatablePad {

    // animate using an image
    func animate(image: UIImage)

    // animate using a colour
    func animate(backgroundColour: UIColor)

    // remove any existing animation
    func clearAnimation()
}
