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

    static let FontPrimaryColor = UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1)
    static let BackgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)

    static let SampleTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)
    static let AnimationTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)
    static let SessionTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)

    static let TableViewSeparatorColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)

    static let PadAreaResizeFactorWhenEditStart: CGFloat = 0.8
    static let PadAreaResizeFactorWhenEditEnd: CGFloat  = 1 / PadAreaResizeFactorWhenEditStart

    static let SectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    static let ItemInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    static let SidePaneTabBarSampleIcon = "sound.png"
    static let SidePaneTabBarAnimationIcon = "params.png"

    static let SampleTableReuseIdentifier = "sampleCell"
    static let AnimationTableReuseIdentifier = "animationCell"
    static let SessionTableReuseIdentifier = "sessionCell"

    static let animationBitColourKey = "colour"
    static let animationBitRowKey = "row"
    static let animationBitColumnKey = "column"
}
