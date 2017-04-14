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
    internal var grid: GridCollectionViewController! =
        GridCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    internal var page: PageCollectionViewController! =
        PageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

    internal var gridCollectionView =
        GridCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    internal var colour: Colour?
    internal var animationSequence = AnimationSequence()
    internal var animationName = Config.NewAnimationTypeDefaultName
    internal var animationTypeCreationMode = AnimationTypeCreationMode.relative

    internal var sampleSettingMode = SampleSettingMode.once

    private var alert = UIAlertController(
        title: Config.RemoveButtonAlertTitle, message: nil, preferredStyle: .alert)
    private var removeSampleAction: UIAlertAction!
    private var removeAnimationAction: UIAlertAction!
    private var removeBothAction: UIAlertAction!
    private var cancelAction: UIAlertAction!

    init(frame: CGRect, session: Session) {
        currentSession = session
        super.init(nibName: nil, bundle: nil)

        buildViewHierarchy()
        setup()
        buildConstraints()
        addGestures()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }

    private func buildViewHierarchy() {
        // added first because this will be behind the grid so it won't block multitouch
        view.addSubview(padSelection)
        view.addSubview(grid.view)
        view.addSubview(page.view)
        view.addSubview(removeButton)
    }

    private func setup() {
        // for some reason we must register this here, instead of in GridCollectionView.viewDidLoad
        gridCollectionView.register(GridCollectionViewCell.self,
                                    forCellWithReuseIdentifier: Config.GridCollectionViewCellIdentifier)
        gridCollectionView.padDelegate = self
        gridCollectionView.backgroundColor = UIColor.clear

        grid.padGrid = currentSession.getGrid(page: currentPage)
        grid.gridDisplayDelegate = self
        grid.collectionView = gridCollectionView

        page.delegate = self
        page.pages = currentSession.numPages

        padSelection.viewController = grid
        removeButton.viewController = grid
        RecorderManager.instance.delegate = self

        removeSampleAction = UIAlertAction(
            title: Config.RemoveButtonSampleTitle, style: .destructive, handler: removeSample)
        removeAnimationAction = UIAlertAction(
            title: Config.RemoveButtonAnimationTitle, style: .destructive, handler: removeAnimation)
        removeBothAction = UIAlertAction(
            title: Config.RemoveButtonBothTitle, style: .destructive, handler: removeBoth)
        cancelAction = UIAlertAction(title: Config.RemoveButtonCancelTitle, style: .default, handler: nil)
    }

    private func buildConstraints() {
        page.view.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(view)
            make.width.equalTo(view).multipliedBy(1.0/9.0).offset(-Config.ItemInsets.right)
        }
        grid.view.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(view)
            make.right.equalTo(page.view.snp.left)
        }
    }

    private func addGestures() {
        removeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFromPad)))
    }

    override func viewDidLayoutSubviews() {
        gridCollectionView.reloadData()
        page.collectionView?.reloadData()
    }

    func getPad(at indexPath: IndexPath) -> Pad {
        return self.currentSession.getPad(page: currentPage, indexPath: indexPath)
    }

    // MARK: Alert related to clearing pad

    func removeSample(_: UIAlertAction) {
        guard let indexPath = selectedIndexPath else {
            return
        }
        getPad(at: indexPath).clearAudio()
        selectedIndexPath = indexPath
    }

    func removeAnimation(_: UIAlertAction) {
        guard let indexPath = selectedIndexPath else {
            return
        }
        getPad(at: indexPath).clearAnimation()
        selectedIndexPath = indexPath
    }

    func removeBoth(_: UIAlertAction) {
        guard let indexPath = selectedIndexPath else {
            return
        }
        getPad(at: indexPath).clearAudio()
        getPad(at: indexPath).clearAnimation()
        selectedIndexPath = indexPath
    }

    // Show an alert to remove something from the pad, where something can be (depending on the pad):
    // 1. only sample
    // 2. only animation
    // 3. both sample and animation
    func removeFromPad() {
        guard let pad = selectedPad else {
            return
        }

        if let audioFile = pad.getAudioFile() {
            //need to stop looping track
            _ = AudioManager.instance.stop(audioDir: audioFile)
            alert.addAction(removeSampleAction)
        }

        if pad.getAnimation() != nil {
            alert.addAction(removeAnimationAction)
        }

        if pad.getAudioFile() != nil && pad.getAnimation() != nil {
            alert.addAction(removeBothAction)
        }

        alert.addAction(cancelAction)
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
            // if in editing mode, selected an already selected pad should preview tjhe pad
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
        selectedIndexPath = indexPath
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
            RecorderManager.instance.recordPad(forPage: currentPage, forIndex: indexPath)
        }
    }
}

extension GridController: SampleTableDelegate {
    func sampleTable(_: UITableView, didSelect sample: String) {
        guard let indexPath = self.selectedIndexPath else {
            return
        }
        currentSession.addAudio(page: currentPage, row: indexPath.section, col: indexPath.row, audioFile: sample)
        sampleSettingMode(selected: sampleSettingMode)
        selectedIndexPath = indexPath
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
        selectedIndexPath = indexPath
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
        currentPage = page
        playSampleAndAnimation(assignedTo: getPad(at: indexPath))
    }
}

extension GridController: SampleSettingDelegate {
    func sampleSettingMode(selected: SampleSettingMode) {
        self.sampleSettingMode = selected
        guard let indexPath = selectedIndexPath else {
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
