//
//  ColourSelection.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Tracks the currently selected colour in the colour picker
class ColourSelection: SelectedPadTrackingView {
    private let width: CGFloat = Config.ColourSelectionWidth
    private let offset: CGFloat = Config.ColourSelectionOffset

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        layer.borderWidth = width
        layer.borderColor = UIColor.green.cgColor
        layer.cornerRadius = width
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func calculateOffset(relativeTo cell: UICollectionViewCell) -> CGRect {
        return CGRect(x: cell.frame.minX - offset,
                      y: cell.frame.minY - offset,
                      width: cell.frame.width + offset * 2,
                      height: cell.frame.width + offset * 2)
    }
}
