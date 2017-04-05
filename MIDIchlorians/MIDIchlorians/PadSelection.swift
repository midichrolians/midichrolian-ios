//
//  PadSelection.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class PadSelection: UIView {
    // Used to get the frame of a cell that this pad selection should be positioned over
    var viewController: UICollectionViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 3.0
        layer.cornerRadius = 5.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Positions this selection at the cell at indexPath
    // If indexPath is nil, remove selection
    func position(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            isHidden = true
            return
        }
        guard let viewController = viewController else {
            return
        }
        let cell = viewController.collectionView(viewController.collectionView!, cellForItemAt: indexPath)

        isHidden = false
        // need to offset the frame by some pixels, increase the width
        let offset = layer.borderWidth + 1
        frame = CGRect(x: cell.frame.minX - offset,
                       y: cell.frame.minY - offset,
                       width: cell.frame.width + offset * 2,
                       height: cell.frame.height + offset * 2)
        setNeedsDisplay()
    }

}
