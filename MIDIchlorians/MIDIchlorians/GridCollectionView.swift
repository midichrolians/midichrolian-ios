//
//  GridCollectionView.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class GridCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var mode: Mode = .Playing {
        didSet {
            if mode == .Playing, let selectedPad = selectedPad {
                unselectCell(at: selectedPad)
            }
        }
    }
    internal var currentSession: Session?
    internal var currentPage = 0

    private let reuseIdentifier = "cell"
    private let audioManager = AudioManager()
    internal var selectedPad: IndexPath?

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

    func selectCell(at indexPath: IndexPath) {
        self.selectedPad = indexPath
        let cell = self.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.red.cgColor
        cell?.layer.borderWidth = 3.0
    }

    func unselectCell(at indexPath: IndexPath) {
        let cell = self.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0.0
    }

    func gridTapped(location: CGPoint) {
        guard let indexPath = self.indexPathForItem(at: location) else {
            return
        }

        // if in editing mode, highlight the tapped grid
        switch mode {
        case .Editing:
            // this is the second tap on a grid, first tap to select, second tap will play
            if self.selectedPad == indexPath {
                // play music
            } else {
                if let selectedPad = selectedPad {
                    self.unselectCell(at: selectedPad)
                }
                self.selectCell(at: indexPath)
                return
            }
        case .Playing:
            break
        }

        // hardcoded animations for demo
        if (indexPath.section == 0 || indexPath.section == Config.numberOfRows - 1) &&
            (indexPath.item == 0 || indexPath.item == Config.numberOfColumns - 1) {
            guard let animationSequence = AnimationTypes.getAnimationSequenceForAnimationType(
                animationTypeName: Config.animationTypeSpreadName,
                indexPath: indexPath) else {
                    return
            }
            AnimationEngine.register(animationSequence: animationSequence)
            return
        }
        if indexPath.section > 1 && indexPath.item > 2 && indexPath.section < 4 && indexPath.item < 5 {
            guard let animationSequence = AnimationTypes.getAnimationSequenceForAnimationType(
                animationTypeName: Config.animationTypeSparkName,
                indexPath: indexPath) else {
                    return
            }
            AnimationEngine.register(animationSequence: animationSequence)
            return
        }
        guard let animationSequence = AnimationTypes.getAnimationSequenceForAnimationType(
            animationTypeName: Config.animationTypeRainbowName,
            indexPath: indexPath) else {
                return
        }
        AnimationEngine.register(animationSequence: animationSequence)
        // end

        // need session to return a pad from an indexPath
    }

    func startListenAudio() {
//        let ncdefault = NotificationCenter.default
//        ncdefault.addObserver(forName: Notification.Name(rawValue:"Sound"), object: nil, queue: nil) { notification in
            //handle notification
//            guard let completedID = notification.userInfo?["completed"] as? UInt32 else {
//                return
//            }
//            let cellPath = self.audioManager.getIndexPath(of: completedID)
//            guard let _ = self.cellForItem(at: cellPath) else {
//                return
//            }
//        }
    }
}

extension GridCollectionView: SampleTableDelegate {
    func sampleTable(_: UITableView, didSelect sample: String) {
        guard let row = self.selectedPad?.section, let col = self.selectedPad?.row else {
            return
        }
        self.currentSession?.addAudio(page: self.currentPage, row: row, col: col, audioFile: sample)
    }
}

extension GridCollectionView: AnimationTableDelegate {
    func animationTable(_: UITableView, didSelect animation: String) {
        guard let indexPath = self.selectedPad else {
            return
        }

        guard let animationSequence = AnimationTypes.getAnimationSequenceForAnimationType(
            animationTypeName: animation, indexPath: indexPath) else {
                return
        }

        self.currentSession?.addAnimation(
            page: self.currentPage, row: indexPath.section, col: indexPath.row, animation: animationSequence)
    }
}
