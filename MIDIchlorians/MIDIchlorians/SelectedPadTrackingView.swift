//
//  SelectedPadTrackingView.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// This view tracks a selected pad in the grid,
// positioning itself relative to that pad.
// Child classes can override the init method to manage how this view looks like
class SelectedPadTrackingView: UIView {
    // Used to get the frame of a cell that this pad selection should be positioned over
    var viewController: UICollectionViewController?

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

        frame = calculateOffset(relativeTo: cell)

        alpha = 0.0
        isHidden = false

        UIView.animate(withDuration: Config.PadSelectionAnimationTime) {
            self.alpha = 1.0
        }
    }

    func calculateOffset(relativeTo cell: UICollectionViewCell) -> CGRect {
        return cell.frame
    }

}
