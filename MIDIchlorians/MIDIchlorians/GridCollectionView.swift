//
//  GridCollectionView.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class GridCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private let reuseIdentifier = "cell"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Config.numberOfColumns
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Config.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath as IndexPath) as? GridCollectionViewCell else {
                    return GridCollectionViewCell()
            }
            cell.rowNumber = indexPath.section
            cell.columnNumber = indexPath.item
            cell.setAppearance()
            return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
        let cellSize = collectionView.frame.size.width/itemsPerRow - 8.0
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            gridTapped(location: touchLocation)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    func gridTapped(location: CGPoint) {
        guard let indexPath = self.indexPathForItem(at: location) else {
            return
        }
        if indexPath.section > 1 && indexPath.item > 2 && indexPath.section < 4 && indexPath.item < 5 {
            let animationSequence = PredefinedAnimationSchemes.spreadOut(indexPath: indexPath)
            AnimationEngine.register(animationSequence: animationSequence)
            return
        }
        let animationSequence = PredefinedAnimationSchemes.rainbow(indexPath: indexPath)
        AnimationEngine.register(animationSequence: animationSequence)
    }
}
