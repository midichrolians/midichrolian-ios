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
    static let numberOfSecondsInMinute = 60
    static let defaultBPM = 120

    static let audioSetting = AudioPlayerSetting.audioServices
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
    static let AnimationExt = "json"
    static let SessionExt = "json"

    static let FontPrimaryColor = UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1)
    static let BackgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let SecondaryBackgroundColor = UIColor.white
    static let FontSecondaryColor = UIColor.darkGray

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

    static let SectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    static let ItemInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    // will be removed once we move to constraints
    static let AppLeftPadding: CGFloat = 20
    static let AppRightPadding: CGFloat = 20

    // Top nav
    static let TopNavHeight: CGFloat = 60
    static let TopNavLogoText = "MIDIchlorians"
    static let TopNavSessionLabel = "Sessions"
    static let TopNavSaveLabel = "Save"
    static let TopNavEditLabel = "Edit"
    static let TopNavExitLabel = "Exit"
    static let TopNavRecordLabel = "Record"
    static let TopNavPlayLabel = "Play"
    static let TopNavRecordIcon = "record.png"
    static let TopNavRecordingBlackIcon = "record_black.png"
    static let TopNavRecordingLoopDuration: TimeInterval = 0.7
    static let TopNavStackViewSpacing: CGFloat = 20

    // Grid
    static let GridCollectionViewCellIdentifier = "cell"
    static let PadSelectionBorderColour = UIColor.green.cgColor
    static let PadSelectionBorderWidth: CGFloat = 3.0
    static let PadSelectionCornerRadius: CGFloat = 5.0
    static let PadSelectionOffset: CGFloat = 2
    static let GridSampleIndicatorIcon = "play.png"
    static let GridAnimationIndicatorIcon = "play.png"

    // SidePane
    static let SidePaneWidth: CGFloat = 320
    static let SidePaneTabBarSampleIcon = "sound.png"
    static let SidePaneTabBarAnimationIcon = "params.png"

    // Bottom pane
    static let BottomPaneHeight = 220

    static let SampleSettingLoopLabel = "Loop"
    static let SampleSettingOnceOffLabel = "Once-off"

    // Page
    static let PageReuseIdentifier = "page"
    static let PageIconName = "padplay.png"
    static let PageSelectedIconName = "padplay_selected.png"

    // Animation Designer
    static let AnimationDesignItemOffset: CGFloat = 20
    static let AnimationDesignerPaneHeightOffset: CGFloat = -200
    static let TimelineHeight: CGFloat = 48
    static let ColourPickerHeight: CGFloat = 60
    static let TimelineTopOffset: CGFloat = 10
    static let ColourPickerTopOffset: CGFloat = 10
    static let AnimationTypeControlTopOffset: CGFloat = 10
    static let ClearSwitchLabelLeftOffset: CGFloat = 40
    static let ClearSwitchLeftOffset: CGFloat = 10
    static let AnimationDesignTimelineLabel = "Animation Timeline"
    static let AnimationDesignColourLabel = "Colour Palette"
    static let AnimationDesignClearLabel = "Clear"
    static let AnimationDesignSaveLabel = "Save Animation"

    // Timeline
    static let TimelineMinNumFrames = 8
    static let TimelineReuseIdentifier = "timeline"
    static let TimelineInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    // ratio of height for unselected over selected frame in timeline
    static let TimelineUnselectedFrameRatio: CGFloat = 0.7

    // Colour picker
    static let ColourSelectionWidth: CGFloat = 3
    static let ColourSelectionOffset: CGFloat = 5
    static let ColourReuseIdentifier = "colour"
    static let ColourInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    static let RemoveButtonOffset: CGFloat = 10
    static let RemoveButtonWidth: CGFloat = 32

    static let SampleTableTitle = "Samples"
    static let SampleTableReuseIdentifier = "sampleCell"
    static let AnimationTableReuseIdentifier = "animationCell"
    static let SessionTableReuseIdentifier = "sessionCell"

    static let SampleTableCellHeight: CGFloat = 60
    static let AnimationTableCellHeight: CGFloat = Config.SampleTableCellHeight

    static let SessionEditAlertTitle = "Enter a new name"
    static let SessionEditOkayTitle = "Save"
    static let SessionEditCancelTitle = "Cancel"

    static let animationBitColourKey = "colour"
    static let animationBitRowKey = "row"
    static let animationBitColumnKey = "column"

    static let animationTypeModeKey = "mode"
    static let animationTypeAnimationSequenceKey = "animationSequence"
    static let animationTypeNameKey = "name"

    static let animationSequenceArrayKey = "animationBitsArray"
    static let animationSequenceNameKey = "name"
    static let animationSequenceFrequencyKey = "frequencyPerBeat"

    static let animationTypeSpreadName = "Spread"
    static let animationTypeSparkName = "Spark"
    static let animationTypeRainbowName = "Rainbow"

    static let DefaultSessionName = "New Session"

    static let SessionTableTitle = "Sessions"
    static let AnimationTabTitle = "Animations"

    static let AudioFolderName = "samples"
    static let AnimationFileName = "animations"
    static let SessionFileName = "sessions"

    static let NewAnimationTypeDefaultName = "Default Animation"

    static let animationNotificationKey = "animation"
    static let sessionNotificationKey = "session"
    static let audioNotificationKey = "audio"
}
