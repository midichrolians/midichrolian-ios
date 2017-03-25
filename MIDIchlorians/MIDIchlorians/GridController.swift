//
//  GridController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 25/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

protocol PadDelegate: class {
    func padTapped(indexPath: IndexPath)
}

// Manages the currently visible grid of pads using a GridCollectionView
class GridController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var view: UICollectionView {
        return gridCollectionView
    }
    var mode: Mode = .Playing {
        didSet {
            self.gridCollectionView.mode = mode
        }
    }

    internal var currentSession: Session?
    internal var currentPage = 0
    internal var selectedPad: IndexPath?
    internal let audioManager = AudioManager()
    internal var gridCollectionView: GridCollectionView

    private let reuseIdentifier = "cell"

    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        self.gridCollectionView = GridCollectionView(frame: frame, collectionViewLayout: layout)
        self.gridCollectionView.backgroundColor = Config.BackgroundColor
        self.currentSession = Session(bpm: Config.defaultBPM)
        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        super.init()

        self.gridCollectionView.dataSource = self
        self.gridCollectionView.delegate = self
        self.gridCollectionView.padDelegate = self

    }

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
        let totalLength = self.gridCollectionView.frame.width
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

extension GridController: PadDelegate {
    func padTapped(indexPath: IndexPath) {
        guard let pad = self.currentSession?.getPad(page: currentPage, indexPath: indexPath) else {
            return
        }
        self.selectedPad = indexPath
        guard let audioFile = pad.getAudioFile() else {
            return
        }
        let _ = audioManager.play(audioDir: audioFile)
    }
}

extension GridController: SampleTableDelegate {
    func sampleTable(_: UITableView, didSelect sample: String) {
        guard let row = self.selectedPad?.section, let col = self.selectedPad?.row else {
            return
        }
        self.currentSession?.addAudio(page: self.currentPage, row: row, col: col, audioFile: sample)
    }
}

extension GridController: AnimationTableDelegate {
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

extension GridController: ModeSwitchDelegate {
    func enterEdit() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditStart)
        self.mode = .Editing
    }

    func enterPlay() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditEnd)
        self.mode = .Playing
    }

    private func resizePads(by factor: CGFloat) {
        // and to animate the changes refer to
        // http://stackoverflow.com/questions/13780153/uicollectionview-animate-cell-size-change-on-selection
        self.gridCollectionView.frame = CGRect(
            origin: self.gridCollectionView.frame.origin,
            size: self.gridCollectionView.frame.size.scale(by: factor))
        self.gridCollectionView.collectionViewLayout.invalidateLayout()
    }
}
