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
class GridController: UIViewController {
    // used for animations
    internal var selectedFrame: Int = 0
    private var removeSampleView: UIButton = UIButton()
    var mode: Mode = .playing {
        didSet {
            // when entering playing or design, reset the selected index path
            if mode == .playing {
                selectedIndexPath = nil
                resetRemoveButton()
            }
        }
    }
    weak var padDelegate: PadDelegate?

    internal var currentSession: Session! {
        didSet {
            grid.padGrid = currentSession.getGrid(page: currentPage)
        }
    }
    internal var currentPage = 0 {
        didSet {
            grid.padGrid = currentSession.getGrid(page: currentPage)
            gridCollectionView.reloadData()
            page.collectionView?.reloadData()
        }
    }
    // Keep the selectedIndexPath of the view controller in sync
    internal var selectedIndexPath: IndexPath? {
        didSet {
            if mode == .editing {
                showRemoveSampleButton(forPadAt: selectedIndexPath)
            }
            if let prev = oldValue {
                gridCollectionView.reloadItems(at: [prev])
            }
            if let cur = selectedIndexPath {
                gridCollectionView.reloadItems(at: [cur])
            }
        }
    }
    internal var grid: GridCollectionViewController! = GridCollectionViewController(
        collectionViewLayout: UICollectionViewFlowLayout())
    internal var page: PageCollectionViewController! = PageCollectionViewController(
        collectionViewLayout: UICollectionViewFlowLayout())

    internal var gridCollectionView: GridCollectionView!
    internal var colour: Colour?
    internal var animationSequence: AnimationSequence = AnimationSequence()
    internal var animationName: String = Config.NewAnimationTypeDefaultName
    internal var animationTypeCreationMode = AnimationTypeCreationMode.absolute

    init(frame: CGRect, session: Session) {
        currentSession = session
        grid.padGrid = currentSession.getGrid(page: currentPage)
        page.pages = currentSession.numPages
        super.init(nibName: nil, bundle: nil)
        page.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLayoutSubviews() {
        gridCollectionView.reloadData()
        page.collectionView?.reloadData()
    }

    override func loadView() {
        view = UIView()

        gridCollectionView = GridCollectionView(frame: CGRect.zero,
                                                collectionViewLayout: grid.collectionViewLayout)
        grid.collectionView = gridCollectionView

        grid.collectionView!.backgroundColor = Config.BackgroundColor

        gridCollectionView.register(GridCollectionViewCell.self,
                                    forCellWithReuseIdentifier: Config.GridCollectionViewCellIdentifier)

        removeSampleView.setTitle("X", for: .normal)
        removeSampleView.backgroundColor = UIColor.blue

        gridCollectionView.padDelegate = self
        view.addSubview(grid.view)

        view.addSubview(page.view)
        page.view.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(view)
            make.width.equalTo(view).multipliedBy(1.0/9.0).offset(-Config.ItemInsets.right)
        }
        page.collectionView!.backgroundColor = Config.BackgroundColor

        grid.view.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(view)
            make.right.equalTo(page.view.snp.left)
        }
        grid.gridDisplayDelegate = self

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
        guard let cell = grid.collectionView(
            grid.collectionView!, cellForItemAt: indexPath) as? GridCollectionViewCell else {
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
        let alert = UIAlertController(title: "Remove sample?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            if let indexPath = self.selectedIndexPath {
                let pad = self.getPad(at: indexPath)
                pad.clearAudio()
                self.gridCollectionView.reloadItems(at: [indexPath])
                self.selectedIndexPath = indexPath
            }
        }))
        present(alert, animated: true, completion: nil)
    }

}

extension GridController: GridDisplayDelegate {
    var frame: Int {
        return selectedFrame
    }
}

extension GridController: PadDelegate {
    func padTapped(indexPath: IndexPath) {
        let pad = getPad(at: indexPath)

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
                if let existingColour = grid.colours[selectedFrame][pad] {
                    self.animationSequence.removeAnimationBit(
                        atTick: selectedFrame,
                        animationBit: AnimationBit(
                            colour: existingColour,
                            row: indexPath.section,
                            column: indexPath.item
                        )
                    )
                }
                grid.colours[selectedFrame][pad] = colour
                self.animationSequence.addAnimationBit(
                    atTick: selectedFrame,
                    animationBit: AnimationBit(
                        colour: colour,
                        row: indexPath.section,
                        column: indexPath.item
                    )
                )
                grid.collectionView?.reloadItems(at: [indexPath])
            } else {
                guard let colourToBeRemoved = grid.colours[selectedFrame][pad] else {
                    return
                }
                self.animationSequence.removeAnimationBit(
                    atTick: selectedFrame,
                    animationBit: AnimationBit(
                        colour: colourToBeRemoved,
                        row: indexPath.section,
                        column: indexPath.item
                    )
                )
                grid.colours[selectedFrame][pad] = nil
                grid.collectionView?.reloadItems(at: [indexPath])
            }
            padDelegate?.pad(animationUpdated: animationSequence)
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
        self.grid.collectionView!.reloadItems(at: [indexPath])
        self.selectedIndexPath = indexPath
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
        self.grid.collectionView!.reloadItems(at: [indexPath])
        self.selectedIndexPath = indexPath
    }

    func addAnimation(_ tableView: UITableView) {
        mode = .design
    }
}

extension GridController: ModeSwitchDelegate {
    func enterEdit() {
        self.mode = .editing
    }

    func enterPlay() {
        self.mode = .playing
    }

    func enterDesign() {
        self.mode = .design
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
        if selectedFrame == frame {
            return
        }
        selectedFrame = frame
        while grid.colours.count <= frame {
            grid.colours.append([Pad: Colour]())
        }
        self.grid.collectionView?.reloadData()
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

extension GridController: PageDelegate {
    func page(selected: Int) {
        currentPage = selected
    }
}
