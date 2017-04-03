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

    let colours = Colour.allColours
    var selectedColour: Colour? {
        didSet {
            setNeedsDisplay()
        }
    }
    private var height: CGFloat {
        return bounds.height
    }
    private var width: CGFloat {
        return height
    }

    override func draw(_ rect: CGRect) {
        // draw a row of colours
        for (i, c) in colours.enumerated() {
            let path = UIBezierPath()
            let start = CGPoint(x: CGFloat(i) * width, y: 0.0)
            path.move(to: start)
            path.addLine(to: CGPoint(x: start.x + width, y: start.y))
            path.addLine(to: CGPoint(x: start.x + width, y: start.y + height))
            path.addLine(to: CGPoint(x: start.x, y: start.y + height))
            path.addLine(to: start)

            path.lineWidth = 0.25

            c.uiColor.setFill()
            c.uiColor.setStroke()
            path.fill()
            path.stroke()

            // highlight currently selected colour
            if selectedColour == c {
                let path = UIBezierPath()
                path.move(to: start)
                path.addLine(to: CGPoint(x: start.x + width, y: start.y))
                path.addLine(to: CGPoint(x: start.x + width, y: start.y + height))
                path.addLine(to: CGPoint(x: start.x, y: start.y + height))
                path.addLine(to: start)
                UIColor.black.setStroke()
                path.lineWidth = 4.0
                path.stroke()
            }
        }
    }

    // Returns index of UIColor frame this point falls into.
    // nil if the point falls outside of the timeline but is captured by this view
    func colour(at point: CGPoint) -> Colour? {
        let i = Int(point.x / width)
        return i >= colours.count ? nil : colours[i]
    }
}
