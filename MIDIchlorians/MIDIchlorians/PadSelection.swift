//
//  PadSelection.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Shows a selection around a cell
class PadSelection: SelectedPadTrackingView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        layer.borderColor = UIColor(colorLiteralRed: 1, green: 1, blue: 255/255, alpha: 0.5).cgColor
        layer.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2).cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func calculateOffset(relativeTo cell: UICollectionViewCell) -> CGRect {
        // This selection should look like a border around the cell
        // need to offset the frame by some pixels, increase the width
        let offset = layer.borderWidth + (cell.frame.width * Config.PadSelectionOffsetRaio)
        let frame = CGRect(x: cell.frame.minX - offset,
                      y: cell.frame.minY - offset,
                      width: cell.frame.width + offset * 2,
                      height: cell.frame.height + offset * 2)
        layer.borderWidth = Config.PadSelectionBorderWidth
        layer.cornerRadius = cell.frame.width * Config.PadSelectionCornerRadiusRatio
        return frame
    }
}
