//
//  GridCollectionViewCell.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

class GridCollectionViewCell: UICollectionViewCell {
    private let sampleOnceOffImage = UIImage(named: Config.PadSampleOnceOffIcon)
    private let sampleLoopImage = UIImage(named: Config.PadSampleLoopIcon)
    private let animationIndicatorImage = UIImage(named: Config.PadAnimationIcon)
    private let playLoopIndicatorImage = UIImage(named: Config.PadAnimationIcon)

    var rowNumber = 0
    var columnNumber = 0
    var sampleIndicator: UIImageView!
    var animationIndicator: UIImageView!
    var imageView: UIImageView!
    private var playLoopIndicator: UIImageView!
    var looping = false {
        didSet {
            guard oldValue != looping else {
                return
            }
            animationIndicator.image = looping ? animationIndicatorImage : nil
        }
    }
    var pad: Pad? {
        didSet {
            guard let pad = pad else {
                clearIndicators()
                return
            }
            // once we have the notion of an audio having loop/onceoff we will update the image accordingly
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

        playLoopIndicator = UIImageView()
        contentView.addSubview(playLoopIndicator)

        layer.cornerRadius = frame.width * Config.PadCornerRadiusRatio

        setConstraints()
    }

    func setConstraints() {
        // add constraints
        sampleIndicator.snp.makeConstraints { make in
            make.width.equalTo(contentView).dividedBy(Config.PadIndicatorRatio)
            make.height.equalTo(sampleIndicator.snp.width)
            make.centerY.centerX.equalTo(contentView)
        }

        animationIndicator.snp.makeConstraints { make in
            make.width.equalTo(contentView).dividedBy(Config.PadIndicatorRatio)
            make.height.equalTo(animationIndicator.snp.width)
            make.bottom.centerX.equalTo(contentView)
        }

        playLoopIndicator.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(contentView.frame.width / 2)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setDefaultAppearance() {
        self.backgroundColor = UIColor.darkGray
    }

    func assign(sample: String) {
        sampleIndicator.image = sampleOnceOffImage
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
