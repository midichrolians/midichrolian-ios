//
//  GridCollectionView.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class GridCollectionView: UICollectionView {
    var mode: Mode = .playing {
        didSet {
            if mode == .playing, let selectedPad = selectedPad {
                unselectCell(at: selectedPad)
            }
        }
    }
    weak var padDelegate: PadDelegate?

    private let audioManager = AudioManager()
    internal var selectedPad: IndexPath?

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

        padDelegate?.padTapped(indexPath: indexPath)

        // if in editing mode, highlight the tapped grid
        switch mode {
        case .editing:
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
        case .playing:
            break
        }

        // hardcoded animations for demo
        if (indexPath.section == 0 || indexPath.section == Config.numberOfRows - 1) &&
            (indexPath.item == 0 || indexPath.item == Config.numberOfColumns - 1) {
            guard let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
                animationTypeName: Config.animationTypeSpreadName,
                indexPath: indexPath) else {
                    return
            }
            AnimationEngine.register(animationSequence: animationSequence)
            return
        }
        if indexPath.section > 1 && indexPath.item > 2 && indexPath.section < 4 && indexPath.item < 5 {
            guard let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
                animationTypeName: Config.animationTypeSparkName,
                indexPath: indexPath) else {
                    return
            }
            AnimationEngine.register(animationSequence: animationSequence)
            return
        }
        guard let animationSequence = AnimationManager.instance.getAnimationSequenceForAnimationType(
            animationTypeName: Config.animationTypeRainbowName,
            indexPath: indexPath) else {
                return
        }
        AnimationEngine.register(animationSequence: animationSequence)
    }

}

extension GridCollectionView: AnimatableGrid {
    func getAnimatablePad(forIndex: IndexPath) -> AnimatablePad? {
        return cellForItem(at: forIndex) as? GridCollectionViewCell
    }
}
