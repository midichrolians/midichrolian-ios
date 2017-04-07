//
//  GridCollectionView.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class GridCollectionView: UICollectionView {
    weak var padDelegate: PadDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)

            guard let indexPath = self.indexPathForItem(at: touchLocation) else {
                return
            }

            padDelegate?.padTapped(indexPath: indexPath)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

}

extension GridCollectionView: AnimatableGrid {
    func getAnimatablePad(forIndex: IndexPath) -> AnimatablePad? {
        if forIndex.section >= self.numberOfSections {
            return nil
        }
        guard let cell = cellForItem(at: forIndex) as? GridCollectionViewCell else {
            return nil
        }
        return cell
    }
}
