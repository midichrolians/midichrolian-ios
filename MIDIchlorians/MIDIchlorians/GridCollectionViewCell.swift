//
//  GridCollectionViewCell.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {

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
}
