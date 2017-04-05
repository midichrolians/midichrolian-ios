//
//  TimelineCollectionViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

private let reuseIdentifier = "timeline"
let inset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

class TimelineCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var minNumFrames = 8
    weak var timelineDelegate: TimelineDelegate?

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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(minNumFrames, max(timelineDelegate?.frame.count ?? minNumFrames, minNumFrames))
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell
        cell.backgroundColor = UIColor.blue

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        timelineDelegate?.timeline(selected: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // we calculate the height of the bigger view first to prevent exceeding the height of the view
        var height = collectionView.frame.height - inset.top - inset.bottom
        let selectedOffsetRatio: CGFloat = 1.3
        // if selected make it bigger
        if timelineDelegate?.selectedFrame != indexPath {
            height /= selectedOffsetRatio
        }
        // if frame has somethign also make it different
        return CGSize(width: height, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset.right
    }

}
