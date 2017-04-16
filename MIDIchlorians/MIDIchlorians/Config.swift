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
    static let invalidBPM = 0
    static let defaultAnimationValue = ""
    static let defaultAudioValue = ""
    static let playBackAccuracy: TimeInterval = 1/60

    static let audioSetting = AudioPlayerSetting.gSAudio
    static let sounds = [
        "Sail": [
            "AWOLNATION - Sail", "AWOLNATION - Sail-1",
            "AWOLNATION - Sail-2", "AWOLNATION - Sail-3",
            "AWOLNATION - Sail-4", "AWOLNATION - Sail-5",
            "AWOLNATION - Sail-6", "AWOLNATION - Sail-7",
            "AWOLNATION - Sail-8", "AWOLNATION - Sail-9",
            "AWOLNATION - Sail-10", "AWOLNATION - Sail-11",
            "AWOLNATION - Sail-12", "AWOLNATION - Sail-13",
            "AWOLNATION - Sail-14", "AWOLNATION - Sail-15",
            "AWOLNATION - Sail-16", "AWOLNATION - Sail-9",
            "AWOLNATION - Sail-10", "AWOLNATION - Sail-17",
            "AWOLNATION - Sail-18", "AWOLNATION - Sail-19",
            "AWOLNATION - Sail-20", "AWOLNATION - Sail-21",
            "AWOLNATION - Sail-22", "AWOLNATION - Sail-23",
            "AWOLNATION - Sail-24", "AWOLNATION - Sail-25",
            "AWOLNATION - Sail-26", "AWOLNATION - Sail-27",
            "AWOLNATION - Sail-28", "AWOLNATION - Sail"
        ],
        "Fur elise": [
            "All Leads - No Sidechain-1", "All Leads - No Sidechain-10",
            "All Leads - No Sidechain-12", "All Leads - No Sidechain-13-1",
            "All Leads - No Sidechain-14", "All Leads - No Sidechain-15",
            "All Leads - No Sidechain-16", "All Leads - No Sidechain-2",
            "All Leads - No Sidechain-3", "All Leads - No Sidechain-4",
            "All Leads - No Sidechain-6", "All Leads - No Sidechain-8",
            "All Leads - No Sidechain",
            "Drop FX", "Fill Kick",
            "Fur Elise Cuts-1", "Fur Elise Cuts-2",
            "Fur Elise Cuts-3", "Fur Elise Cuts", "Intro",
            "KICK HIT", "KICK",
            "KickfeMain", "Mel Bass",
            "Mel Kick Bass", "Mel Kick",
            "Ride and Clap", "SNARE HIT",
            "SNARE", "SnarefurE", "Start FX",
            "VOX", "hit"
        ],
        "Mortal Kombat": [
            "1", "10", "11", "12",
            "13", "14", "15", "16",
            "17", "18", "19", "2",
            "20", "21", "22", "23",
            "25", "3", "4", "5",
            "6", "7", "8", "9"
        ],
        "Drums": [
            "clap-808", "clap-analog",
            "clap-crushed", "clap-fat",
            "clap-slapper", "clap-tape",
            "cowbell-808", "crash-808",
            "crash-acoustic", "crash-noise",
            "crash-tape", "hihat-808",
            "hihat-acoustic01", "hihat-acoustic02",
            "hihat-analog", "hihat-digital",
            "hihat-dist01", "hihat-dist02",
            "hihat-electro", "hihat-plain",
            "hihat-reso", "hihat-ring",
            "kick-808", "kick-acoustic01",
            "kick-acoustic02", "kick-big",
            "kick-classic", "kick-cultivator",
            "kick-deep", "kick-dry",
            "kick-electro01", "kick-electro02",
            "kick-floppy", "kick-gritty",
            "kick-heavy", "kick-newwave",
            "kick-oldschool", "kick-plain",
            "kick-slapback", "kick-softy",
            "kick-stomp", "kick-tape",
            "kick-thump", "kick-tight",
            "kick-tron", "kick-vinyl01",
            "kick-vinyl02", "kick-zapper",
            "openhat-808", "openhat-acoustic01",
            "openhat-analog", "openhat-slick",
            "openhat-tight", "perc-808",
            "perc-chirpy", "perc-hollow",
            "perc-laser", "perc-metal",
            "perc-nasty", "perc-short",
            "perc-tambo", "perc-tribal",
            "perc-weirdo", "ride-acoustic01",
            "ride-acoustic02", "shaker-analog",
            "shaker-shuffle", "shaker-suckup",
            "snare-808", "snare-acoustic01",
            "snare-acoustic02", "snare-analog",
            "snare-big", "snare-block",
            "snare-brute", "snare-dist01",
            "snare-dist02", "snare-dist03",
            "snare-electro", "snare-lofi01",
            "snare-lofi02", "snare-modular",
            "snare-noise", "snare-pinch",
            "snare-punch", "snare-smasher",
            "snare-sumo", "snare-tape",
            "snare-vinyl01", "snare-vinyl02",
            "tom-808", "tom-acoustic01",
            "tom-acoustic02", "tom-analog",
            "tom-chiptune", "tom-fm",
            "tom-lofi", "tom-rototom",
            "tom-short"
        ]
    ]

    static let preloadedAnimationTypes = [
        "Spark", "Rainbow", "Spread"
    ]
    static let SoundExt = "wav"
    static let AnimationExt = "json"
    static let SessionExt = "json"
    static let DefaultSessionsName = "DefaultSessions"
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

    // Common
    static let PopOverDismissLabel = "PopoverDismissRegion"
    static let CommonEditActionTitle = "Edit"
    static let CommonRemoveActionTitle = "Remove"
    static let CommonButtonCancelTitle = "Cancel"
    static let CommonButtonOkayTitle = "Okay"
    static let CommonButtonConfirmTitle = "Confirm"
    static let CommonSystemAddTitle = "Add"

    // Top nav
    static let TopNavHeight: CGFloat = 60
    static let TopNavLogoIcon = "logo.png"
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
    static let TopNavStackViewSpacing: CGFloat = 10
    static let TopNavSyncLabel = "Sync"
    static let TopNavLoginTitle = "Login"
    static let TopNavLogoutTitle = "Logout"
    static let TopNavSyncUploadTitle = "Upload"
    static let TopNavSyncDownloadTitle = "Download"
    static let TopNavHelpLabel = "?"
    static let TopNavSyncPreferredWidth: CGFloat = 200
    static let TopNavSyncPreferredHeight: CGFloat = 150
    static let TopNavBPMTitleFormat = "%d BPM"
    static let TopNavBPMMinBPM = 100
    static let TopNavBPMDefaultBPM = 128
    static let TopNavBPMMaxBPM = 140
    static let TopNavBPMPreferredWidth: CGFloat = 150
    static let TopNavBPMPreferredHeight: CGFloat = 200
    static let TopNavSyncSpinnerInset: CGFloat = 20
    static let TopNavSessionNameMaxWidth: CGFloat = 150
    static let TopNavSessionTitleA11yLabel = "Session title"

    // About
    static let AboutCloseTitle = "Close"
    static let AboutCloseInset: CGFloat = 10
    static let AboutCloseWidth: CGFloat = 50
    static let AboutSlideshowInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)

    // Grid
    static let GridA11yLabel = "Grid"
    static let GridCollectionViewCellA11yLabel = "Animation image"
    static let GridCollectionViewCellIdentifier = "cell"
    static let GridDefaultBackgroundColour = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    static let PadSelectionBorderWidth: CGFloat = 1.0
    static let PadSelectionCornerRadiusRatio: CGFloat = 1 / 16.0
    static let PadSelectionOffsetRaio: CGFloat =  1 / 12.0
    static let PadSelectionAnimationTime: TimeInterval = 0.3
    static let PadSampleOnceOffIcon = "pad_sample_once_off.png"
    static let PadSampleLoopIcon = "pad_sample_loop.png"
    static let PadAnimationIcon = "pad_animation.png"
    static let PadPlayLoopIcon = "pad_loop_indicator.png"
    static let PadIndicatorRatio: CGFloat = 3
    static let RemoveButtonA11yLabel = "Remove Pad"
    static let RemoveButtonOffset: CGFloat = 10
    static let RemoveButtonWidth: CGFloat = 24
    static let PadCornerRadiusRatio: CGFloat = 1 / 24.0
    static let PadCornerBorderWidthRatio: CGFloat = 1 / 64.0
    static let PadPlayLoopIndicatorRatio: CGFloat = 16.0
    static let PadPlayLoopIndicatorInset: CGFloat = 10

    // Remove button
    static let RemoveButtonIcon = "cancel.png"
    static let RemoveButtonAlertTitle = "Confirm"
    static let RemoveButtonSampleTitle = "Remove sample"
    static let RemoveButtonAnimationTitle = "Remove animation"
    static let RemoveButtonBothTitle = "Remove both"
    static let RemoveButtonCancelTitle = "Cancel"

    // SidePane
    static let SidePaneWidth: CGFloat = 320
    static let SidePaneTabBarSampleIcon = "sound.png"
    static let SidePaneTabBarAnimationIcon = "params.png"

    // Group table
    static let GroupTableA11yLabel = "Group Table"
    static let GroupTableReuseIdentifier = "group"
    static let GroupAlertTitle = "Group name"
    static let GroupNameOkayTitle = "Okay"
    static let GroupNameCancelTitle = "Cancel"

    // Sample table
    static let SampleTableA11yLabel = "Sample Table"
    static let SampleTableCellHeight: CGFloat = 60
    static let SampleTableTitle = "Samples"
    static let SampleTableReuseIdentifier = "sampleCell"
    static let SampleRemoveTitleFormat = "Remove %@?"
    static let SampleRemoveConfirmTitle = "Confirm"
    static let SampleRemoveCancelTitle = "Cancel"
    static let SamplePlayButtonIcon = "play.png"

    // Animation table
    static let AnimationTableA11YLabel = "Animation Table"
    static let AnimationTableReuseIdentifier = "animationCell"
    static let AnimationEditActionTitle = "Edit"
    static let AnimationRemoveActionTitle = "Remove"
    static let AnimationEditAlertTitle = "Enter a new name"
    static let AnimationEditOkayTitle = "Okay"
    static let AnimationEditCancelTitle = "Cancel"
    static let AnimationRemoveTitleFormat = "Remove %@?"
    static let AnimationRemoveConfirmTitle = "Confirm"
    static let AnimationRemoveCancelTitle = "Cancel"
    static let AnimationTableCellHeight: CGFloat = Config.SampleTableCellHeight
    static let AnimationTabTitle = "Animations"

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
    static let TimelineNumSections = 1
    static let TimelineBorderWidth: CGFloat = 5.0
    static let TimelineBorderColour = UIColor.gray.cgColor
    static let TimelineCornerRadiusRatio: CGFloat = 1 / 2.0
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
    static let AnimationSaveAlertTitle = "Name for animation"
    static let AnimationSaveOkayTitle = "Save"
    static let AnimationSaveCancelTitle = "Cancel"

    // Timeline
    static let TimelineA11yLabel = "Timeline"
    static let TimelineMinNumFrames = 8
    static let TimelineReuseIdentifier = "timeline"
    static let TimelineInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    // ratio of height for unselected over selected frame in timeline
    static let TimelineUnselectedFrameRatio: CGFloat = 0.7

    // Colour picker
    static let ColourPickerA11yLabel = "Colour Picker"
    static let ColourSelectionWidth: CGFloat = 3
    static let ColourSelectionOffset: CGFloat = 5
    static let ColourReuseIdentifier = "colour"
    static let ColourInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    static let ColourClearAnimImage = "clear_anim.png"

    // Session
    static let SessionTableA11yLabel = "Session Table"
    static let SessionTableTitle = "Sessions"
    static let SessionEditActionTitle = "Edit"
    static let SessionRemoveActionTitle = "Remove"
    static let SessionEditAlertTitle = "Enter a new name"
    static let SessionEditOkayTitle = "Okay"
    static let SessionEditCancelTitle = "Cancel"
    static let SessionRemoveTitleFormat = "Remove %@?"
    static let SessionRemoveConfirmTitle = "Confirm"
    static let SessionRemoveCancelTitle = "Cancel"
    static let SessionTableReuseIdentifier = "sessionCell"
    static let DefaultSessionName = "New Session"

    // About / Tutorial
    static let TutorialImages = [
        "tutorial_1.png", "tutorial_2.png", "tutorial_3.png",
        "tutorial_4.png", "tutorial_5.png", "tutorial_6.png",
        "tutorial_7.png", "tutorial_8.png", "tutorial_9.png"
    ]

    static let animationBitColourKey = "colour"
    static let animationBitRowKey = "row"
    static let animationBitColumnKey = "column"

    static let animationTypeModeKey = "mode"
    static let animationTypeAnimationSequenceKey = "animationSequence"
    static let animationTypeNameKey = "name"
    static let animationTypeAnchorRowKey = "anchorRow"
    static let animationTypeAnchorColumnKey = "anchorColumn"

    static let animationSequenceArrayKey = "animationBitsArray"
    static let animationSequenceNameKey = "name"
    static let animationSequenceFrequencyKey = "frequencyPerBeat"

    static let AudioFolderName = "samples"
    static let AnimationFileName = "animations"
    static let SessionFileName = "sessions"

    static let NewAnimationTypeDefaultName = "Default Animation"

    static let animationTypeSpreadName = "Spread"
    static let animationTypeSparkName = "Spark"
    static let animationTypeRainbowName = "Rainbow"

    static let audioNotificationKey = "Audio"
    static let animationNotificationKey = "Animation"
    static let sessionNotificationKey = "Session"
    static let cloudNotificationKey = "Cloud"

    static let defaultGroup = "Your samples"

    static let colourPurpleImageName = "purpleButton"
    static let colourLightBlueImageName = "lightBlueButton"
    static let colourBlueImageName = "blueButton"
    static let colourGreenImageName = "greenButton"
    static let colourYellowImageName = "yellowButton"
    static let colourPinkImageName = "pinkButton"
    static let colourRedImageName = "redButton"
}
