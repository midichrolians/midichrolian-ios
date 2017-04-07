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
    var mode: Mode = .playing {
        didSet {
            // when entering playing or design, reset the selected index path
            if mode == .playing {
                padSelection.position(at: nil)
                removeButton.position(at: nil)
            }
        }
    }
    private var padSelection = PadSelection()
    private var removeButton = RemoveButton()
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
                padSelection.position(at: selectedIndexPath)
                // only show if pad has audio selected
                if selectedPad?.getAudioFile() != nil || selectedPad?.getAnimation() != nil {
                    removeButton.position(at: selectedIndexPath)
                } else {
                    removeButton.position(at: nil)
                }
            }
            if let prev = oldValue {
                gridCollectionView.reloadItems(at: [prev])
            }
            if let cur = selectedIndexPath {
                gridCollectionView.reloadItems(at: [cur])
            }
        }
    }
    internal var selectedPad: Pad? {
        guard let indexPath = selectedIndexPath else {
            return nil
        }
        return getPad(at: indexPath)
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
        super.init(nibName: nil, bundle: nil)
        grid.padGrid = currentSession.getGrid(page: currentPage)
        page.pages = currentSession.numPages
        grid.gridDisplayDelegate = self
        page.delegate = self
        padSelection.viewController = grid
        removeButton.viewController = grid
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

        // set up pad selection view
        // added first because this will be behind the grid so it won't block multitouch
        view.addSubview(padSelection)

        // set up grid collection view
        gridCollectionView = GridCollectionView(frame: CGRect.zero,
                                                collectionViewLayout: grid.collectionViewLayout)
        grid.collectionView = gridCollectionView
        // we want the pad selection to show through
        gridCollectionView.backgroundColor = UIColor.clear
        gridCollectionView.register(GridCollectionViewCell.self,
                                    forCellWithReuseIdentifier: Config.GridCollectionViewCellIdentifier)
        gridCollectionView.padDelegate = self
        view.addSubview(grid.view)

        // set up page collection view
        view.addSubview(page.view)
        page.collectionView!.backgroundColor = Config.BackgroundColor

        // set up remove button
        view.addSubview(removeButton)
        removeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFromPad)))

        // set up constraints
        page.view.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(view)
            make.width.equalTo(view).multipliedBy(1.0/9.0).offset(-Config.ItemInsets.right)
        }
        grid.view.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(view)
            make.right.equalTo(page.view.snp.left)
        }
    }

    func getPad(at indexPath: IndexPath) -> Pad {
        return self.currentSession.getPad(page: currentPage, indexPath: indexPath)
    }

    // Show an alert to remove something from the pad, where something can be:
    // 1. only sample
    // 2. only animation
    // 3. both sample and animation
    // depending on what the pad has
    func removeFromPad() {
        guard let indexPath = selectedIndexPath else {
            return
        }
        let pad = getPad(at: indexPath)

        let alert = UIAlertController(title: Config.RemoveButtonAlertTitle, message: nil, preferredStyle: .alert)

        if pad.getAudioFile() != nil {
            alert.addAction(UIAlertAction(title: Config.RemoveButtonSampleTitle, style: .destructive, handler: { _ in
                pad.clearAudio()
                self.gridCollectionView.reloadItems(at: [indexPath])
                self.selectedIndexPath = indexPath
            }))
        }

        if pad.getAnimation() != nil {
            alert.addAction(UIAlertAction(title: Config.RemoveButtonAnimationTitle, style: .destructive, handler: { _ in
                pad.clearAnimation()
                self.gridCollectionView.reloadItems(at: [indexPath])
                self.selectedIndexPath = indexPath
            }))
        }

        if pad.getAudioFile() != nil && pad.getAnimation() != nil {
            alert.addAction(UIAlertAction(title: Config.RemoveButtonBothTitle, style: .destructive, handler: { _ in
                pad.clearAudio()
                pad.clearAnimation()
                self.gridCollectionView.reloadItems(at: [indexPath])
                self.selectedIndexPath = indexPath
            }))
        }

        alert.addAction(UIAlertAction(title: Config.RemoveButtonCancelTitle, style: .default, handler: nil))
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
        //RECORDING HACK
        if TimeTracker.instance.getRecording {
            TimeTracker.instance.setTimePadPair(pageNum: 0, forIndex: indexPath)
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

    func saveAnimation(name: String) {
        guard let indexPath = selectedIndexPath else {
            return
        }
        _ = AnimationManager.instance.addNewAnimationType(
            name: name,
            animationSequence: self.animationSequence,
            mode: self.animationTypeCreationMode,
            anchor: indexPath
        )
    }
}

extension GridController: PageDelegate {
    func page(selected: Int) {
        switch mode {
        case .playing:
            fallthrough
        case .editing:
            currentPage = selected
        case .design:
            // page selection is not allowed in design mode, it will be confusing
            // since animations are only defined and shown for one grid at a time
            break
        }
    }
}
