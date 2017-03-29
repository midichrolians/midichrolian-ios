//
//  GridCollectionViewCell.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell, PadView {
    var rowNumber = 0
    var columnNumber = 0

    func setDefaultAppearance() {
        self.backgroundColor = UIColor.darkGray
    }
}

extension GridCollectionViewCell: AnimatablePad {

    func animate(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame.size = self.frame.size
        self.contentView.addSubview(imageView)
    }

    func animate(backgroundColour: UIColor) {
        self.backgroundColor = backgroundColour
    }

    func clearAnimation() {
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        setDefaultAppearance()
    }

    func assign(sample: String) {
    }

    func assign(animation: AnimationSequence) {
    }

    // This cell is selected in the edit mode
    func setSelected() {
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 3.0
    }

    func unselect() {
        layer.borderWidth = 0.0
    }
}
