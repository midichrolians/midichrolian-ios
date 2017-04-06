//
//  TimelineCollectionViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class TimelineCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    weak var timelineDelegate: TimelineDelegate?

    private var minNumFrames = Config.TimelineMinNumFrames
    private let reuseIdentifier = Config.TimelineReuseIdentifier
    private let insets = Config.TimelineInsets

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(minNumFrames, max(timelineDelegate?.frame.count ?? minNumFrames, minNumFrames))
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell
        cell.backgroundColor = UIColor.blue
        cell.layer.cornerRadius = cell.frame.width / 2

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        timelineDelegate?.timeline(selected: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // we calculate the height of the bigger view first to prevent exceeding the height of the view
        var height = collectionView.frame.height - insets.top - insets.bottom

        // if not selected make it smaller
        if timelineDelegate?.selectedFrame != indexPath {
            height *= Config.TimelineUnselectedFrameRatio
        }

        // if frame has something also make it different
        return CGSize(width: height, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insets.right
    }

}
