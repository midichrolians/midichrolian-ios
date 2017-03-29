//
//  AnimatablePad.swift
//  MIDIchlorians
//
//  Created by anands on 24/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

protocol AnimatablePad {

    func animate(image: UIImage)

    func animate(backgroundColour: UIColor)

    func clearAnimation()
}
