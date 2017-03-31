//
//  Config.swift
//  MIDIchlorians
//
//  Created by anands on 10/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

struct Config {
    static let numberOfRows = 6
    static let numberOfColumns = 8
    static let numberOfPages = 6
    static let animationFrequency = 16
    static let defaultBPM = 120
    static let sound = [
        [
            "AWOLNATION - Sail", "AWOLNATION - Sail-1",
            "AWOLNATION - Sail-2", "AWOLNATION - Sail-3",
            "AWOLNATION - Sail-4", "AWOLNATION - Sail-5",
            "AWOLNATION - Sail-6", "AWOLNATION - Sail-7"
        ], [
            "AWOLNATION - Sail-8", "AWOLNATION - Sail-9",
            "AWOLNATION - Sail-10", "AWOLNATION - Sail-11",
            "AWOLNATION - Sail-12", "AWOLNATION - Sail-13",
            "AWOLNATION - Sail-14", "AWOLNATION - Sail-15"
        ], [
            "AWOLNATION - Sail-16", "AWOLNATION - Sail-9",
            "AWOLNATION - Sail-10", "AWOLNATION - Sail-17",
            "AWOLNATION - Sail-18", "AWOLNATION - Sail-19",
            "AWOLNATION - Sail-20", "AWOLNATION - Sail-21"
        ], [
            "AWOLNATION - Sail-22", "AWOLNATION - Sail-23",
            "AWOLNATION - Sail-24", "AWOLNATION - Sail-25",
            "AWOLNATION - Sail-26", "AWOLNATION - Sail-27",
            "AWOLNATION - Sail-28", "AWOLNATION - Sail"
        ]
    ]
    static let SoundExt = "wav"

    static let FontPrimaryColor = UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1)
    static let BackgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)

    static let SampleTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)
    static let AnimationTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)
    static let SessionTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)

    static let TableViewSeparatorColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)

    static let PadAreaResizeFactorWhenEditStart: CGFloat = 0.67
    static let PadAreaResizeFactorWhenEditEnd: CGFloat  = 1 / PadAreaResizeFactorWhenEditStart

//    static let MainViewWidthToGridWidthRatio: CGFloat = 2 / 3
    static let MainViewHeightToGridMinYRatio: CGFloat = 1 / 8
    static let MainViewHeightToGridHeightRatio: CGFloat = 7 / 8

    static let MainViewWidthToSideMinXRatio: CGFloat = 2 / 3
    static let MainViewHeightToSideMinYRatio: CGFloat = 1 / 8
    static let MainViewWidthToSideWidthRatio: CGFloat = 1 / 3
    static let MainViewHeightToSideHeightRatio: CGFloat = 7 / 8

    static let MainViewHeightToAnimMinYRatio: CGFloat = 6 / 8
    static let MainViewHeightToAnimHeightRatio: CGFloat = 1 / 4
    static let MainViewWidthToAnimWidthRatio: CGFloat = 7 / 12

    static let SectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    static let ItemInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    // will be removed once we move to constraints
    static let AppLeftPadding: CGFloat = 20
    static let AppRightPadding: CGFloat = 20
    static let TopNavHeight: CGFloat = 60

    static let SidePaneTabBarSampleIcon = "sound.png"
    static let SidePaneTabBarAnimationIcon = "params.png"

    static let SampleTableTitle = "Samples"
    static let SampleTableReuseIdentifier = "sampleCell"
    static let AnimationTableReuseIdentifier = "animationCell"
    static let SessionTableReuseIdentifier = "sessionCell"

    static let animationBitColourKey = "colour"
    static let animationBitRowKey = "row"
    static let animationBitColumnKey = "column"

    static let animationTypeModeKey = "mode"
    static let animationTypeAnimationSequenceKey = "animationSequence"
    static let animationTypeNameKey = "name"

    static let animationSequenceArrayKey = "animationBitsArray"
    static let animationSequenceNameKey = "name"

    static let animationTypeSpreadName = "Spread"
    static let animationTypeSparkName = "Spark"
    static let animationTypeRainbowName = "Rainbow"

    static let TopNavTitle = "MIDIchlorians"
    static let TopNavSessionTitle = "Sessions"
    static let ModeSegmentTitles = ["PLAY", "EDIT"]

    static let DefaultSessionName = "New Session"

    static let SessionTableTitle = "Sessions"
    static let AnimationTabTitle = "Animations"

    static let GridCollectionViewCellIdentifier = "cell"
}
