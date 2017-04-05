//
//  TimelineView.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 29/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class TimelineView: UIView {
    // a data structure of animation frames
    // keep track of which frame is selected currently and show it differently
    private let fullCircle: CGFloat = CGFloat(2 * M_PI)
    internal var selectedFrameIndex: Int?

    var frames: [Bool] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    let colours = [
        UIColor.blue, UIColor.red,
        UIColor.blue, UIColor.red,
        UIColor.blue, UIColor.red,
        UIColor.blue, UIColor.red
    ]
    var height: CGFloat {
        return self.bounds.height
    }
    var width: CGFloat {
        return self.height
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

            c.setFill()
            c.setStroke()
            path.fill()
            path.stroke()

            if i < frames.count && frames[i] {
                // if frames have animation data, stroke a circle
                let ctr = CGPoint(x: CGFloat(i) * width + (width / 2), y : height / 2)
                let dot = UIBezierPath()
                dot.addArc(withCenter: ctr, radius: width / 5, startAngle: 0, endAngle: fullCircle, clockwise: true)
                UIColor.black.setStroke()
                UIColor.black.setFill()
                dot.fill()
                dot.stroke()
            }

            if i == selectedFrameIndex {
                // highlight this frame
            }
        }
    }

    // Returns index of timeline frame this point falls into.
    // nil if the point falls outside of the timeline but is captured by this view
    func frameIndex(at point: CGPoint) -> Int? {
        let i = Int(point.x / width)
        return i >= colours.count ? nil : i
    }

}
