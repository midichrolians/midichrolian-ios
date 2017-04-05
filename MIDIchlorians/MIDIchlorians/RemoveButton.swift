//
//  RemoveButton.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

class RemoveButton: SelectedPadTrackingView {
    override func draw(_ rect: CGRect) {
        let c = UIColor.red
        let width = frame.width
        let height = width
        let path = UIBezierPath()
        let start = CGPoint(x: CGFloat(0) * width, y: 0.0)
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

    override func calculateOffset(relativeTo cell: UICollectionViewCell) -> CGRect {
        return CGRect(x: cell.frame.minX - Config.RemoveButtonOffset,
                      y: cell.frame.minY - Config.RemoveButtonOffset,
                      width: Config.RemoveButtonWidth,
                      height: Config.RemoveButtonWidth)
    }

}
