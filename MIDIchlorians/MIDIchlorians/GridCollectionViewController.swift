//
//  GridCollectionViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 25/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Provides the data source and layout information for the underying GridCollectionView
// Events that happen on the collection view will be sent to the parent GridController, not this view controller.
class GridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // the currently visible 6x8 grid of pads
    var padGrid: [[Pad]] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    // temp hack to get colours to show up on grid when designing
    var colours: [[Pad:Colour]] = [[:]]
    var selectedFrame: Int = 0

    // currently selected pad, only used for edit mode
    var selectedIndexPath: IndexPath? {
        didSet {
            // reload previously selected pad to clear selection
            if let prevIndexPath = oldValue {
                collectionView?.reloadItems(at: [prevIndexPath])
            }
            // reload new selected pad to show selection
            if let newIndexPath = selectedIndexPath {
                collectionView?.reloadItems(at: [newIndexPath])
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Config.numberOfRows
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Config.numberOfColumns
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Config.GridCollectionViewCellIdentifier,
                for: indexPath as IndexPath) as? GridCollectionViewCell else {
                    return GridCollectionViewCell()
            }

            let pad = padGrid[indexPath.section][indexPath.row]

            if let sample = pad.getAudioFile() {
                cell.assign(sample: sample)
            }

            if let animation = pad.getAnimation() {
                cell.assign(animation: animation)
            }

            if selectedIndexPath == indexPath {
                cell.setSelected()
            } else {
                cell.unselect()
            }

            cell.rowNumber = indexPath.section
            cell.columnNumber = indexPath.item
            cell.setDefaultAppearance()

            if let colour = colours[selectedFrame][pad] {
                cell.animate(backgroundColour: colour.uiColor)
            }

            return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalLength = collectionView.frame.width
        // need to + 1 cos of the page buttons, this will be changed soon
        let itemsPerRow = CGFloat(collectionView.numberOfItems(inSection: indexPath.section)) + 1
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

}
