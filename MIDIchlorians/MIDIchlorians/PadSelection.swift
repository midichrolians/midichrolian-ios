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
        layer.borderColor = Config.PadSelectionBorderColour
        layer.borderWidth = Config.PadSelectionBorderWidth
        layer.cornerRadius = Config.PadSelectionCornerRadius
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func calculateOffset(relativeTo cell: UICollectionViewCell) -> CGRect {
        // This selection should look like a border around the cell
        // need to offset the frame by some pixels, increase the width
        let offset = layer.borderWidth + Config.PadSelectionOffset
        return CGRect(x: cell.frame.minX - offset,
                      y: cell.frame.minY - offset,
                      width: cell.frame.width + offset * 2,
                      height: cell.frame.height + offset * 2)
    }
}
