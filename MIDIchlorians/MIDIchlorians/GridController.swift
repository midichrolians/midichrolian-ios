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
            // when entering playing, reset the selected index path
            if mode == .playing {
                padSelection.position(at: nil)
                removeButton.position(at: nil)
            }
            grid.collectionView?.reloadData()
        }
    }
    private var padSelection = PadSelection()
    private var removeButton = RemoveButton()
    weak var padDelegate: PadDelegate?
    weak var animationDesignerDelegate: AnimationDesignerDelegate?

    internal var currentSession: Session! {
        didSet {
            grid.padGrid = currentSession.getGrid(page: currentPage)
        }
    }
    internal var currentPage = 0 {
        didSet {
            // slight optimaization, don't do anything if the page doesnt change
            if oldValue != currentPage {
                grid.padGrid = currentSession.getGrid(page: currentPage)
                gridCollectionView.reloadData()
                page.collectionView?.reloadData()
            }
        }
    }
    // Keep the selectedIndexPath of the view controller in sync
    internal var selectedIndexPath: IndexPath? {
        didSet {
            if mode == .editing {
                padSelection.position(at: selectedIndexPath)
                // only show if pad has audio or animation selected
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
    internal var animationTypeCreationMode = AnimationTypeCreationMode.relative

    internal var sampleSettingMode = SampleSettingMode.once

    init(frame: CGRect, session: Session) {
        currentSession = session
        super.init(nibName: nil, bundle: nil)
        grid.padGrid = currentSession.getGrid(page: currentPage)
        page.pages = currentSession.numPages
        grid.gridDisplayDelegate = self
        page.delegate = self
        padSelection.viewController = grid
        removeButton.viewController = grid
        RecorderManager.instance.delegate = self
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

        // set up pad selection view
        // add it to the grid's view because frame is calculate in that coordinate system
        grid.view.insertSubview(padSelection, at: 0)

        // set up remove button
        // similarly add it to the grid's view for its coordinate system
        grid.view.addSubview(removeButton)
        removeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFromPad)))

        let numCol = 8 // need to replace this with call to session
        // set up constraints
        page.view.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.right.equalTo(view).inset(Config.AppRightPadding)
            // calculate how much width the page selector will need
            // first subtract away the app padding on the left and right,
            // and compensate with the right inset width
            let offset = Config.ItemInsets.right - Config.AppLeftPadding - Config.AppRightPadding
            // because of the way snapkit constraints is set up, we cannot offset then divide,
            // so we make use of this inequality to divide then offset
            // make.width = (view.width + offset) / num - inset.right
            //            = (view.width / num) + (offset / num) - inset.right
            make.width.equalTo(view)
                .dividedBy(numCol + 1)
                .offset(offset / CGFloat(numCol + 1) - Config.ItemInsets.right)
        }
        grid.view.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.equalTo(view).inset(Config.AppLeftPadding)
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

        if let audioFile = pad.getAudioFile() {
            //need to stop looping track
            _ = AudioManager.instance.stop(audioDir: audioFile)
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

    // Actually play the sample and animation assigned to a pad
    func playSampleAndAnimation(assignedTo pad: Pad) {
        padDelegate?.pad(played: pad)

        if let animationSequence = pad.getAnimation() {
            AnimationEngine.register(animationSequence: animationSequence)
        }

        if let audioFile = pad.getAudioFile() {
            _ = AudioManager.instance.play(audioDir: audioFile, bpm: pad.getBPM())
        }
    }

}

extension GridController: GridDisplayDelegate {
    var frame: Int {
        return selectedFrame
    }
}

extension GridController: PadDelegate {
    func padTapped(indexPath: IndexPath) {
        switch mode {
        case .design:
            padInDesign(indexPath: indexPath)
        case .editing:
            if selectedIndexPath != indexPath {
                padInEdit(indexPath: indexPath)
            } else {
                fallthrough
            }
        case .playing:
            padInPlay(indexPath: indexPath)
        }
    }

    private func padInEdit(indexPath: IndexPath) {
        // if in editing mode, highlight the tapped grid
        let pad = getPad(at: indexPath)
        self.selectedIndexPath = indexPath
        padDelegate?.pad(selected: pad)
    }

    private func padInDesign(indexPath: IndexPath) {
        let pad = getPad(at: indexPath)

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
    }

    private func padInPlay(indexPath: IndexPath) {
        let pad = getPad(at: indexPath)
        padDelegate?.pad(played: pad)

        if let animationSequence = pad.getAnimation() {
            AnimationEngine.register(animationSequence: animationSequence)
        }

        if let audioFile = pad.getAudioFile() {
            _ = AudioManager.instance.play(audioDir: audioFile, bpm: pad.getBPM())
            // first we check if this pad is looping, we do that by checking bpm
            let isLooping = pad.getBPM() != nil
            // check if it is playing, AudioManager would have played/stopped a looping track,
            // so checking the state here will allow us to decide if we want to show or hide the indicator
            if isLooping { // we only care that a pad has a looping track
                // if it is playing we want the tap to stop the audio playing
                let isPlaying = AudioManager.instance.isTrackPlaying(audioDir: audioFile)
                if isPlaying {
                    // the pad is now playing, so add the loop indicator
                    grid.looping.insert(pad)
                    grid.collectionView?.reloadItems(at: [indexPath])
                } else {
                    grid.looping.remove(pad)
                    grid.collectionView?.reloadItems(at: [indexPath])
                }
            }
        }

        if RecorderManager.instance.isRecording {
            RecorderManager.instance.recordPad(forPage: self.currentPage, forIndex: indexPath)
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
        if self.sampleSettingMode == SampleSettingMode.loop {
            self.currentSession.addBPMToPad(
                page: self.currentPage, row: row, col: col, bpm: self.currentSession.getSessionBPM())
        } else {
            self.currentSession.clearBPMAtPad(page: self.currentPage, row: row, col: col)
        }
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
        // reset design related structures
        animationSequence = AnimationSequence()
        grid.colours = [[:]]
        selectedFrame = 0
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
        animationDesignerDelegate?.saveAnimation(name: name)
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

extension GridController: RecordPlaybackDelegate {
    func playPad(page: Int, indexPath: IndexPath) {
        // switch to the required page
        currentPage = page
        // then get the pad and play it
        let pad = getPad(at: indexPath)
        playSampleAndAnimation(assignedTo: pad)
    }
}

extension GridController: SampleSettingDelegate {
    func sampleSettingMode(selected: SampleSettingMode) {
        self.sampleSettingMode = selected
        guard let indexPath = self.selectedIndexPath else {
            return
        }

        switch selected {
        case .loop:
            currentSession.addBPMToPad(
                page: currentPage, row: indexPath.section, col: indexPath.row, bpm: currentSession.getSessionBPM())
        case .once:
            currentSession.clearBPMAtPad(page: currentPage, row: indexPath.section, col: indexPath.row)
        }
        grid.collectionView?.reloadItems(at: [indexPath])
    }
}
