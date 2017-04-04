//
//  GridController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 25/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

// Manages the currently visible grid of pads using a GridCollectionView
class GridController: NSObject {
    var view: UIView
    var gridView: GridCollectionView {
        return gridCollectionView
    }
    private var removeSampleView: UIButton
    var mode: Mode = .playing {
        didSet {
            // when entering playing or design, reset the selected index path
            if mode == .playing {
                selectedIndexPath = nil
            }
            gridCollectionVC.mode = mode
            // when we enter playing mode, want to set unselect pads
        }
    }
    weak var padDelegate: PadDelegate?

    internal var currentSession: Session {
        didSet {
            gridCollectionVC.padGrid = currentSession.getGrid(page: currentPage)
        }
    }
    internal var currentPage = 0
    // Keep the selectedIndexPath of the view controller in sync
    internal var selectedIndexPath: IndexPath? {
        didSet {
            gridCollectionVC.selectedIndexPath = selectedIndexPath

            if mode == .editing {
                showRemoveSampleButton(forPadAt: selectedIndexPath)
            }
        }
    }
    internal var gridCollectionVC: GridCollectionViewController

    internal var gridCollectionView: GridCollectionView
    internal var colour: Colour?
    internal var animationSequence: AnimationSequence
    internal var animationName: String = Config.NewAnimationTypeDefaultName
    internal var animationTypeCreationMode = AnimationTypeCreationMode.absolute

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

        self.animationSequence = AnimationSequence()

        removeSampleView = UIButton(frame: CGRect.zero)
        removeSampleView.setTitle("X", for: .normal)
        removeSampleView.backgroundColor = UIColor.blue

        super.init()

        gridCollectionView.padDelegate = self
        view.addSubview(gridCollectionVC.collectionView!)

        view.addSubview(removeSampleView)
    }

    func getPad(at indexPath: IndexPath) -> Pad {
        return self.currentSession.getPad(page: currentPage, indexPath: indexPath)
    }

    // Resets the position of the remove sample button
    private func resetRemoveButton() {
        removeSampleView.frame = CGRect.zero
    }

    func showRemoveSampleButton(forPadAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            resetRemoveButton()
            return
        }
        let pad = getPad(at: indexPath)
        guard pad.getAudioFile() != nil else {
            resetRemoveButton()
            return
        }
        // first see if the pad has a sample assinged
        guard let cell = gridCollectionVC.collectionView(
            gridCollectionVC.collectionView!, cellForItemAt: indexPath) as? GridCollectionViewCell else {
                return
        }

        let cellFrame = cell.frame
        removeSampleView.frame = CGRect(x: cellFrame.minX - 5,
                                        y: cellFrame.minY - 5,
                                        width: cellFrame.width / 3,
                                        height: cellFrame.width / 3)
        removeSampleView.addTarget(self, action: #selector(removeSample), for: .touchDown)
    }

    func removeSample() {
        print("remove sample")
    }

}

extension GridController: PadDelegate {
    func padTapped(indexPath: IndexPath) {
        let pad = self.currentSession.getPad(page: currentPage, indexPath: indexPath)

        // if in editing mode, highlight the tapped grid
        if mode == .editing && selectedIndexPath != indexPath {
            self.selectedIndexPath = indexPath
            padDelegate?.pad(selected: pad)
            return
        }

        if mode == .design {
            if let colour = self.colour {
                // in design mode and we have a colour selected, so change the colour
                // temp heck to change colour, since Pad doesn't have a colour
                gridCollectionVC.colours[gridCollectionVC.selectedFrame][pad] = colour
                self.animationSequence.addAnimationBit(
                    atTick: gridCollectionVC.selectedFrame,
                    animationBit: AnimationBit(
                        colour: colour,
                        row: indexPath.section,
                        column: indexPath.item
                    )
                )

                gridCollectionVC.collectionView?.reloadItems(at: [indexPath])
            } else {
                gridCollectionVC.colours[gridCollectionVC.selectedFrame][pad] = nil
                gridCollectionVC.collectionView?.reloadItems(at: [indexPath])
            }
            // prevent the pad from being played in design mode
            return
        }

        padDelegate?.pad(played: pad)

        if let animationSequence = pad.getAnimation() {
            AnimationEngine.register(animationSequence: animationSequence)
        }

        if let audioFile = pad.getAudioFile() {
            _ = AudioManager.instance.play(audioDir: audioFile)
        }
    }
}

extension GridController: SampleTableDelegate {
    func sampleTable(_: UITableView, didSelect sample: String) {
        guard let indexPath = self.selectedIndexPath else {
            return
        }
        guard let row = self.selectedIndexPath?.section, let col = self.selectedIndexPath?.row else {
            return
        }
        self.currentSession.addAudio(page: self.currentPage, row: row, col: col, audioFile: sample)
        self.gridCollectionVC.collectionView!.reloadItems(at: [indexPath])
    }
}

extension GridController: AnimationTableDelegate {
    func animationTable(_: UITableView, didSelect animation: String) {
        guard let indexPath = self.selectedIndexPath else {
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

    func addAnimation(_ tableView: UITableView) {
        mode = .design
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

    func enterDesign() {
        self.mode = .design
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

extension GridController: AnimationDesignerDelegate {
    func animationColour(selected colour: Colour) {
        self.colour = colour
    }

    func animationClear() {
        self.colour = nil
    }

    func animationTimeline(selected frame: Int) {
        if self.gridCollectionVC.selectedFrame == frame {
            return
        }
        self.gridCollectionVC.selectedFrame = frame
        while gridCollectionVC.colours.count <= frame {
            gridCollectionVC.colours.append([Pad: Colour]())
        }
        self.gridCollectionVC.collectionView?.reloadData()
    }

    func animationTypeCreationMode(selected mode: AnimationTypeCreationMode) {
        self.animationTypeCreationMode = mode
    }

    func saveAnimation() {
        guard let indexPath = selectedIndexPath else {
            return
        }
        _ = AnimationManager.instance.addNewAnimationType(
            name: self.animationName,
            animationSequence: self.animationSequence,
            mode: self.animationTypeCreationMode,
            anchor: indexPath
        )
    }
}
