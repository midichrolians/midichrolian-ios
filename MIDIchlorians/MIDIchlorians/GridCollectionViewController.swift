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
    var padGrid: [[Pad]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

            cell.rowNumber = indexPath.section
            cell.columnNumber = indexPath.item
            cell.setDefaultAppearance()
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
