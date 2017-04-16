//
//  TimelineCollectionViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

// Displays a timeline of animation frames.
// The timeline is used when designing custom animations.
// It displays up to 8 selectable frames, and the user can design a different configuration
// of pad to animation colours for each frame.
class TimelineCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    weak var timelineDelegate: TimelineDelegate?

    private var minNumFrames = Config.timelineMinNumFrames
    private let reuseIdentifier = Config.timelineReuseIdentifier
    private let insets = Config.timelineInsets

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(recognizer:)))
        self.collectionView!.addGestureRecognizer(panGesture)
        collectionView?.accessibilityLabel = Config.timelineA11yLabel
    }

    func pan(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: collectionView!)
        guard let indexPath = collectionView?.indexPathForItem(at: point) else {
            return
        }
        collectionView(collectionView!, didSelectItemAt: indexPath)
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

        cell.backgroundColor = UIColor.white
        if let frame = timelineDelegate?.frame, indexPath.row < frame.count && frame[indexPath.row] {
            cell.backgroundColor = UIColor.gray
        }

        cell.layer.borderWidth = Config.timelineBorderWidth
        cell.layer.borderColor = Config.timelineBorderColour
        cell.layer.cornerRadius = cell.frame.width * Config.timelineCornerRadiusRatio

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
            height *= Config.timelineUnselectedFrameRatio
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
