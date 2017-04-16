//
//  GridController+PadDelegate.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 15/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation

// Updates data strucutres and grid view when the pad is tapped
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

    private func removeAnimation(colour: Colour, indexPath: IndexPath) {
        animationSequence.removeAnimationBit(
            atTick: selectedFrame,
            animationBit: AnimationBit(colour: colour, row: indexPath.section, column: indexPath.item)
        )
    }

    private func padInDesign(indexPath: IndexPath) {
        let pad = getPad(at: indexPath)

        if let colour = self.colour {
            // in design mode and we have a colour selected, so change the colour
            // temp heck to change colour, since Pad doesn't have a colour
            if let existingColour = grid.colours[selectedFrame][pad] {
                removeAnimation(colour: existingColour, indexPath: indexPath)
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
            removeAnimation(colour: colourToBeRemoved, indexPath: indexPath)
            grid.colours[selectedFrame][pad] = nil
            grid.collectionView?.reloadItems(at: [indexPath])
        }
        padDelegate?.pad(animationUpdated: animationSequence)
    }

    private func padInPlay(indexPath: IndexPath) {
        let pad = getPad(at: indexPath)
        padDelegate?.pad(played: pad)

        if let animationSequence = pad.getAnimation() {
            AnimationEngine.register(animationSequence: animationSequence)
        }

        if RecorderManager.instance.isRecording {
            RecorderManager.instance.recordPad(forPage: currentPage, forIndex: indexPath)
        }

        guard let audioFile = pad.getAudioFile() else {
            return
        }

        _ = AudioManager.instance.play(audioDir: audioFile, bpm: pad.getBPM())
        // first we check if this pad is looping, we do that by checking bpm
        let isLooping = pad.getBPM() != nil
        // check if it is playing, AudioManager would have played/stopped a looping track,
        // so checking the state here will allow us to decide if we want to show or hide the indicator
        let isPlaying = AudioManager.instance.isTrackPlaying(audioDir: audioFile)
        if isLooping && isPlaying {
            grid.looping.insert(pad)
            grid.collectionView?.reloadItems(at: [indexPath])
        } else if isLooping && !isPlaying {
            grid.looping.remove(pad)
            grid.collectionView?.reloadItems(at: [indexPath])
        }
    }
}
