//
//  ColourPicker.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 29/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class ColourPicker: UIView {
    // colour palette that we support
    let colours = [
        UIColor.blue,
        UIColor.red,
        UIColor.cyan,
        UIColor.green,
        UIColor.purple,
        UIColor.indigo
    ]

    override func draw(_ rect: CGRect) {
        // draw a row of colours
        let height: CGFloat = self.bounds.height
        let width: CGFloat = height
        for (i, c) in colours.enumerated() {
            let path = UIBezierPath()
            let start = CGPoint(x: CGFloat(i) * width, y: 0.0)
            path.move(to: start)
            path.addLine(to: CGPoint(x: start.x + width, y: start.y))
            path.addLine(to: CGPoint(x: start.x + width, y: start.y + height))
            path.addLine(to: CGPoint(x: start.x, y: start.y + height))
            path.addLine(to: start)

            path.lineWidth = 0.25

            c.setFill()
            c.setStroke()
            path.fill()
            path.stroke()
        }
    }

}
