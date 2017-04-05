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

    private let reuseIdentifier = "colour"
    private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return colourDelegate?.colours.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        guard let colour = colourDelegate?.colours[indexPath.row] else {
            return cell
        }

        print("cell frame: \(cell.frame)")

        cell.backgroundView = UIImageView(image: colour.image)

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
