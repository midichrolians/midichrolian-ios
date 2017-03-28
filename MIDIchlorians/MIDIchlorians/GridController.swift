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
class GridController: NSObject {
    var view: UIView
    var gridView: GridCollectionView {
        return gridCollectionView
    }
    var mode: Mode = .playing {
        didSet {
            gridCollectionView.mode = mode
        }
    }

    internal var currentSession: Session
    internal var currentPage = 0
    internal var selectedPad: IndexPath?
    internal var gridCollectionVC: GridCollectionViewController

    private var gridCollectionView: GridCollectionView

    init(frame: CGRect, session: Session) {
        // base ui view for the grid
        view = UIView(frame: frame)
        currentSession = session

        let layout = UICollectionViewFlowLayout()
        gridCollectionVC = GridCollectionViewController(collectionViewLayout: layout)
        gridCollectionVC.padGrid = currentSession.getGrid(page: currentPage)

        gridCollectionView = GridCollectionView(frame: frame, collectionViewLayout: layout)
        gridCollectionView.register(GridCollectionViewCell.self,
                                    forCellWithReuseIdentifier: Config.GridCollectionViewCellIdentifier)

        gridCollectionVC.collectionView = gridCollectionView

        gridCollectionVC.collectionView!.backgroundColor = Config.BackgroundColor

        super.init()

        gridCollectionView.padDelegate = self
        view.addSubview(gridCollectionVC.collectionView!)

    }

}

extension GridController: PadDelegate {
    func padTapped(indexPath: IndexPath) {
        let pad = self.currentSession.getPad(page: currentPage, indexPath: indexPath)
        self.selectedPad = indexPath
        guard let audioFile = pad.getAudioFile() else {
            return
        }
        _ = AudioManager.instance.play(audioDir: audioFile)
    }
}

extension GridController: SampleTableDelegate {
    func sampleTable(_: UITableView, didSelect sample: String) {
        guard let indexPath = self.selectedPad else {
            return
        }
        guard let row = self.selectedPad?.section, let col = self.selectedPad?.row else {
            return
        }
        self.currentSession.addAudio(page: self.currentPage, row: row, col: col, audioFile: sample)
        self.gridCollectionVC.collectionView!.reloadItems(at: [indexPath])
    }
}

extension GridController: AnimationTableDelegate {
    func animationTable(_: UITableView, didSelect animation: String) {
        guard let indexPath = self.selectedPad else {
            return
        }

        guard let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: animation, indexPath: indexPath) else {
                return
        }

        self.currentSession.addAnimation(
            page: self.currentPage, row: indexPath.section, col: indexPath.row, animation: animationSequence)
        self.gridCollectionVC.collectionView!.reloadItems(at: [indexPath])
    }
}

extension GridController: ModeSwitchDelegate {
    func enterEdit() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditStart)
        self.mode = .editing
    }

    func enterPlay() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditEnd)
        self.mode = .playing
    }

    private func resizePads(by factor: CGFloat) {
        // and to animate the changes refer to
        // http://stackoverflow.com/questions/13780153/uicollectionview-animate-cell-size-change-on-selection
        let collectionView = gridCollectionVC.collectionView!
        collectionView.frame = CGRect(
            origin: collectionView.frame.origin,
            size: collectionView.frame.size.scale(by: factor))
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
