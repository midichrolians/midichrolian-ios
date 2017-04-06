//
//  ColourCollectionViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class ColourCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    weak var colourDelegate: ColourPickerDelegate?

    private let reuseIdentifier = Config.ColourReuseIdentifier
    private let inset = Config.ColourInsets

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return (colourDelegate?.colours.count ?? 0) + 1 // because of clear
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        if colourDelegate?.colours.count ?? 0 <= indexPath.row {
            cell.backgroundColor = UIColor.blue
            return cell
        }

        guard let colour = colourDelegate?.colours[indexPath.row] else {
            return cell
        }

        cell.backgroundView = UIImageView(image: colour.image)

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < colourDelegate?.colours.count ?? 0 else {
            colourDelegate?.clear(indexPath: indexPath)
            return
        }

        guard let colour = colourDelegate?.colours[indexPath.row] else {
            return
        }
        colourDelegate?.colour(selected: colour, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return inset
    }

}
