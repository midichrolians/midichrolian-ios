//
//  ViewController.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

extension ViewController: EditButtonDelegate {
    func editStart() {
        resizePads(by: Config.PadAreaResizeFactorWhenEditStart)
        self.editPaneController?.view.isHidden = false
    }

    func editEnd() {
        self.editPaneController?.view.isHidden = true
        resizePads(by: Config.PadAreaResizeFactorWhenEditEnd)
    }

    private func resizePads(by factor: CGFloat) {
        // TODO extend UIView to add methods for updating size?
        // and to animate the changes refer to
        // http://stackoverflow.com/questions/13780153/uicollectionview-animate-cell-size-change-on-selection
        self.gridCollection.frame = CGRect(
            origin: self.gridCollection.frame.origin,
            size: self.gridCollection.frame.size.scale(by: factor))
        self.gridCollection.collectionViewLayout.invalidateLayout()
    }
}

class ViewController: UIViewController {
    @IBOutlet var gridCollection: GridCollectionView!
    var editButtonController: EditButton!
    var editPaneController: EditPane!

    override func viewDidLoad() {
        super.viewDidLoad()

        // fix the width of the button collection view
        let totalWidth = self.view.frame.width - 20 - 20 // padding left and right
        // left with 9 columns of buttons with 8 insets in between
        // so to get width for the pads we add 1 inset and times 8/9
        let padWidth = (totalWidth + Config.ItemInsets.right) *
            (CGFloat(Config.numberOfColumns) / CGFloat(Config.numberOfColumns + 1))
        let padHeight = padWidth / CGFloat(Config.numberOfColumns) * CGFloat(Config.numberOfRows)
        gridCollection.frame = CGRect(
            origin: gridCollection.frame.origin,
            size: CGSize(width: padWidth, height: padHeight))

        editButtonController = EditButton(superview: self.view, delegate: self)
        editPaneController = EditPane(superview: self.view)

        gridCollection.dataSource = gridCollection
        gridCollection.delegate = gridCollection
        AnimationEngine.set(animationCollectionView: gridCollection)
        AnimationEngine.start()
        gridCollection.startListenAudio()
    }
}
