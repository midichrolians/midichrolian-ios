//
//  GridCollectionView.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class GridCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "cell"
    private let audioManager = AudioManager()

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
        let totalLength = self.frame.width
        let itemsPerRow = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
        let insetLength = Config.ItemInsets.left * (itemsPerRow + 1)
        let availableLength = totalLength - insetLength
        let itemLength = availableLength / itemsPerRow
        return CGSize(width: itemLength, height: itemLength)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Config.ItemInsets.left
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.ItemInsets.top
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Config.SectionInsets
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
        if (indexPath.section == 0 || indexPath.section == Config.numberOfRows - 1) &&
            (indexPath.item == 0 || indexPath.item == Config.numberOfColumns - 1) {
            let animationSequence = PredefinedAnimationSchemes.spreadFromCenter()
            AnimationEngine.register(animationSequence: animationSequence)
            return
        }
        if indexPath.section > 1 && indexPath.item > 2 && indexPath.section < 4 && indexPath.item < 5 {
            let animationSequence = PredefinedAnimationSchemes.spreadOut(indexPath: indexPath)
            AnimationEngine.register(animationSequence: animationSequence)
            return
        }
        let animationSequence = PredefinedAnimationSchemes.rainbow(indexPath: indexPath)
        AnimationEngine.register(animationSequence: animationSequence)
        _ = audioManager.play(indexPath: indexPath)
    }

    func startListenAudio() {
        let ncdefault = NotificationCenter.default
        ncdefault.addObserver(forName: Notification.Name(rawValue:"Sound"), object: nil, queue: nil) { notification in
            //handle notification
            guard let completedID = notification.userInfo?["completed"] as? UInt32 else {
                return
            }
            let cellPath = self.audioManager.getIndexPath(of: completedID)
            guard let _ = self.cellForItem(at: cellPath) else {
                return
            }
        }
    }
}
