//
//  ViewController.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var gridCollection: GridCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        gridCollection.dataSource = gridCollection
        gridCollection.delegate = gridCollection
        AnimationEngine.set(animationCollectionView: gridCollection)
        AnimationEngine.start()
        gridCollection.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(ViewController.gridTapped(gesture:))
        ))
    }

    func gridTapped(gesture: UIGestureRecognizer) {
        let location = gesture.location(in: gridCollection)
        guard let indexPath = gridCollection.indexPathForItem(at: location) else {
            return
        }
        let animationSequence = AnimationSequence()
        animationSequence.addAnimationBit(
            atTick: 0,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section, column: indexPath.item)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section + 1, column: indexPath.item)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section - 1, column: indexPath.item)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section, column: indexPath.item + 1)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section, column: indexPath.item - 1)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section + 2, column: indexPath.item)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section - 2, column: indexPath.item)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section, column: indexPath.item + 2)
        )
        animationSequence.addAnimationBit(
            atTick: 1,
            animationBit: AnimationBit(colour: UIColor.green, row: indexPath.section, column: indexPath.item - 2)
        )
        AnimationEngine.register(animationSequence: animationSequence)
    }
}
