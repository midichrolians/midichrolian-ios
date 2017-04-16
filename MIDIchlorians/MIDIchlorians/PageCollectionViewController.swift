//
//  PageCollectionViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 4/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Manages the page selectors to change between pages of grid
class PageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var pages: Int = 0
    weak var delegate: PageDelegate?
    private var pageIcon = UIImage(named: Config.pageIconName)
    private var pageSelectedIcon = UIImage(named: Config.pageSelectedIconName)

    private let reuseIdentifier = Config.pageReuseIdentifier

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.backgroundColor = Config.backgroundColor
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages
    }

    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell
        cell.backgroundColor = UIColor.clear
        cell.tintColor = UIColor.white
        cell.backgroundView = UIImageView(image: pageIcon)

        // use a different image if this page is selected
        if delegate?.currentPage == indexPath.row {
            cell.backgroundView = UIImageView(image: pageSelectedIcon)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.itemInsets.top
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Config.sectionInsets
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.page(selected: indexPath.row)
    }

}
