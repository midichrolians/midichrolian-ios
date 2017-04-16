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
    private let sampleOnceOffImage = UIImage(named: Config.padSampleOnceOffIcon)
    private let sampleLoopImage = UIImage(named: Config.padSampleLoopIcon)
    private let animationIndicatorImage = UIImage(named: Config.padAnimationIcon)
    private let playLoopIndicatorImage = UIImage(named: Config.padPlayLoopIcon)

    var rowNumber = 0
    var columnNumber = 0
    var sampleIndicator = UIImageView()
    var animationIndicator = UIImageView()
    var imageView: UIImageView = UIImageView()
    private var playLoopIndicator = UIImageView()
    var looping = false {
        didSet {
            // if looping, animate blinking
            if looping {
                playLoopIndicator.alpha = 1
            } else {
                playLoopIndicator.alpha = 0
            }
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
                assign(sample: sample, isLooping: pad.getBPM() != nil)
            }
            if let animation = pad.getAnimation() {
                assign(animation: animation)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        buildViewHierarchy()
        setConstraints()
    }

    func setUp() {
        playLoopIndicator.image = playLoopIndicatorImage
        playLoopIndicator.alpha = 0
        layer.cornerRadius = frame.width * Config.padCornerRadiusRatio
        imageView.accessibilityLabel = Config.gridCollectionViewCellA11yLabel
    }

    func buildViewHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(sampleIndicator)
        contentView.addSubview(playLoopIndicator)
        contentView.addSubview(animationIndicator)
    }

    func setConstraints() {
        // add constraints
        sampleIndicator.snp.makeConstraints { make in
            make.width.equalTo(contentView).dividedBy(Config.padIndicatorRatio)
            make.height.equalTo(sampleIndicator.snp.width)
            make.centerY.centerX.equalTo(contentView)
        }

        animationIndicator.snp.makeConstraints { make in
            make.width.equalTo(contentView).dividedBy(Config.padIndicatorRatio)
            make.height.equalTo(animationIndicator.snp.width)
            make.bottom.centerX.equalTo(contentView)
        }

        playLoopIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(contentView).dividedBy(Config.padPlayLoopIndicatorRatio)
            make.bottom.right.equalToSuperview().inset(Config.padPlayLoopIndicatorInset)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setDefaultAppearance() {
        self.backgroundColor = UIColor.darkGray
    }

    func assign(sample: String, isLooping: Bool) {
        if isLooping {
            sampleIndicator.image = sampleLoopImage
        } else {
            sampleIndicator.image = sampleOnceOffImage
        }
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
