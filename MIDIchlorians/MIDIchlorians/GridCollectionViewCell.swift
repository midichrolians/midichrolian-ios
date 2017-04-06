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
    private let sampleIndicatorImage = UIImage(named: Config.GridSampleIndicatorIcon)
    private let animationIndicatorImage = UIImage(named: Config.GridAnimationIndicatorIcon)
    var rowNumber = 0
    var columnNumber = 0
    var sampleIndicator: UIImageView!
    var animationIndicator: UIImageView!
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

        imageView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(imageView)

        sampleIndicator = UIImageView()
        contentView.addSubview(sampleIndicator)

        animationIndicator = UIImageView()
        contentView.addSubview(animationIndicator)

        // add constraints
        sampleIndicator.snp.makeConstraints { make in
            make.width.equalTo(contentView).dividedBy(3)
            make.height.equalTo(sampleIndicator.snp.width)
            make.bottom.left.equalTo(contentView)
        }

        animationIndicator.snp.makeConstraints { make in
            make.width.equalTo(contentView).dividedBy(3)
            make.height.equalTo(animationIndicator.snp.width)
            make.bottom.right.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setDefaultAppearance() {
        self.backgroundColor = UIColor.darkGray
    }

    func assign(sample: String) {
        sampleIndicator.image = sampleIndicatorImage
    }

    func assign(animation: AnimationSequence) {
        animationIndicator.image = animationIndicatorImage
    }

    func clearIndicators() {
        sampleIndicator.image = nil
        animationIndicator.image = nil
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
