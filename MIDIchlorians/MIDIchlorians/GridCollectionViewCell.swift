//
//  GridCollectionViewCell.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

class GridCollectionViewCell: UICollectionViewCell, PadView {
    var rowNumber = 0
    var columnNumber = 0
    var sampleLabel: UILabel!
    var animationLabel: UILabel!
    var imageView: UIImageView!
    var pad: Pad? {
        didSet {
            guard let pad = pad else {
                clearIndicators()
                return
            }
            if let sample = pad.getAudioFile() {
                assign(sample: sample)
            }
            if let animation = pad.getAnimation() {
                assign(animation: animation)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sampleLabel = UILabel(frame: CGRect.zero)
        sampleLabel.textAlignment = .center
        contentView.addSubview(sampleLabel)

        animationLabel = UILabel(frame: CGRect.zero)
        sampleLabel.textAlignment = .center
        contentView.addSubview(animationLabel)

        imageView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setDefaultAppearance() {
        self.backgroundColor = UIColor.darkGray
    }

    func assign(sample: String) {
        sampleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.left.equalTo(contentView)
            make.width.equalTo(contentView).dividedBy(2)
        }
        sampleLabel.text = "S"
    }

    func assign(animation: AnimationSequence) {
        animationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
            make.width.equalTo(contentView).dividedBy(2)
        }
        animationLabel.text = "A"
    }

    func clearIndicators() {
        sampleLabel.text = nil
        animationLabel.text = nil
    }
}

extension GridCollectionViewCell: AnimatablePad {

    func animate(image: UIImage) {
        imageView.frame = contentView.frame
        imageView.image = image
    }

    func animate(backgroundColour: UIColor) {
        self.backgroundColor = backgroundColour
    }

    func clearAnimation() {
        imageView.image = nil
        setDefaultAppearance()
    }
}
