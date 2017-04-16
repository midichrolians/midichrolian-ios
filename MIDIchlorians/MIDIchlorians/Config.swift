//
//  Config.swift
//  MIDIchlorians
//
//  Created by anands on 10/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

struct Config {
    static let numberOfRows = 6
    static let numberOfColumns = 8
    static let numberOfPages = 6
    static let numberOfSecondsInMinute = 60
    static let defaultBPM = 120
    static let invalidBPM = 0
    static let numberOfItemsToSync = 3
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
            "AWOLNATION - Sail-16", "AWOLNATION - Sail-17",
            "AWOLNATION - Sail-18", "AWOLNATION - Sail-19",
            "AWOLNATION - Sail-20", "AWOLNATION - Sail-21",
            "AWOLNATION - Sail-22", "AWOLNATION - Sail-23",
            "AWOLNATION - Sail-24", "AWOLNATION - Sail-25",
            "AWOLNATION - Sail-26", "AWOLNATION - Sail-27",
            "AWOLNATION - Sail-28"
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
    static let soundExt = "wav"
    static let animationExt = "json"
    static let sessionExt = "json"
    static let defaultSessionsName = "DefaultSessions"
    static let preloadedSessionsFileName = "DefaultSessions"
    static let fontPrimaryColor = UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1)
    static let backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let secondaryBackgroundColor = UIColor.white
    static let fontSecondaryColor = UIColor.darkGray

    static let sampleTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)
    static let animationTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)
    static let sessionTableViewCellColor = UIColor(red: 110/255, green: 110/255, blue: 116/255, alpha: 1)

    static let tableViewSeparatorColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)

    static let padAreaResizeFactorWhenEditStart: CGFloat = 0.67
    static let padAreaResizeFactorWhenEditEnd: CGFloat  = 1 / padAreaResizeFactorWhenEditStart

//    static let mainViewWidthToGridWidthRatio: CGFloat = 2 / 3
    static let mainViewHeightToGridMinYRatio: CGFloat = 1 / 8
    static let mainViewHeightToGridHeightRatio: CGFloat = 7 / 8

    static let mainViewWidthToSideMinXRatio: CGFloat = 2 / 3
    static let mainViewHeightToSideMinYRatio: CGFloat = 1 / 8
    static let mainViewWidthToSideWidthRatio: CGFloat = 1 / 3
    static let mainViewHeightToSideHeightRatio: CGFloat = 7 / 8

    static let mainViewHeightToAnimMinYRatio: CGFloat = 6 / 8
    static let mainViewHeightToAnimHeightRatio: CGFloat = 1 / 4
    static let mainViewWidthToAnimWidthRatio: CGFloat = 7 / 12

    static let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    static let itemInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    // will be removed once we move to constraints
    static let appLeftPadding: CGFloat = 20
    static let appRightPadding: CGFloat = 20

    // Common
    static let popOverDismissLabel = "PopoverDismissRegion"
    static let commonEditActionTitle = "Edit"
    static let commonRemoveActionTitle = "Remove"
    static let commonButtonCancelTitle = "Cancel"
    static let commonButtonOkayTitle = "Okay"
    static let commonButtonConfirmTitle = "Confirm"
    static let commonSystemAddTitle = "Add"

    // Top nav
    static let topNavHeight: CGFloat = 60
    static let topNavLogoIcon = "logo.png"
    static let topNavLogoText = "MIDIchlorians"
    static let topNavSessionLabel = "Sessions"
    static let topNavSaveLabel = "Save"
    static let topNavEditLabel = "Edit"
    static let topNavExitLabel = "Exit"
    static let topNavRecordLabel = "Record"
    static let topNavPlayLabel = "Play"
    static let topNavRecordIcon = "record.png"
    static let topNavRecordingBlackIcon = "record_black.png"
    static let topNavRecordingLoopDuration: TimeInterval = 0.7
    static let topNavStackViewSpacing: CGFloat = 10
    static let topNavSyncLabel = "Sync"
    static let topNavLoginTitle = "Login"
    static let topNavLogoutTitle = "Logout"
    static let topNavSyncUploadTitle = "Upload"
    static let topNavSyncDownloadTitle = "Download"
    static let topNavHelpLabel = "?"
    static let topNavSyncPreferredWidth: CGFloat = 200
    static let topNavSyncPreferredHeight: CGFloat = 150
    static let topNavBPMTitleFormat = "%d BPM"
    static let topNavBPMMinBPM = 100
    static let topNavBPMDefaultBPM = 128
    static let topNavBPMMaxBPM = 140
    static let topNavBPMPreferredWidth: CGFloat = 150
    static let topNavBPMPreferredHeight: CGFloat = 200
    static let topNavSyncSpinnerInset: CGFloat = 20
    static let topNavSessionNameMaxWidth: CGFloat = 150
    static let topNavSessionTitleA11yLabel = "Session title"

    // About
    static let aboutCloseTitle = "Close"
    static let aboutCloseInset: CGFloat = 10
    static let aboutCloseWidth: CGFloat = 50
    static let aboutSlideshowInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)

    // Grid
    static let gridA11yLabel = "Grid"
    static let gridCollectionViewCellA11yLabel = "Animation image"
    static let gridCollectionViewCellIdentifier = "cell"
    static let gridDefaultBackgroundColour = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    static let padSelectionBorderWidth: CGFloat = 1.0
    static let padSelectionCornerRadiusRatio: CGFloat = 1 / 16.0
    static let padSelectionOffsetRaio: CGFloat =  1 / 12.0
    static let padSelectionAnimationTime: TimeInterval = 0.3
    static let padSampleOnceOffIcon = "pad_sample_once_off.png"
    static let padSampleLoopIcon = "pad_sample_loop.png"
    static let padAnimationIcon = "pad_animation.png"
    static let padPlayLoopIcon = "pad_loop_indicator.png"
    static let padIndicatorRatio: CGFloat = 3
    static let removeButtonA11yLabel = "Remove Pad"
    static let removeButtonOffset: CGFloat = 10
    static let removeButtonWidth: CGFloat = 24
    static let padCornerRadiusRatio: CGFloat = 1 / 24.0
    static let padCornerBorderWidthRatio: CGFloat = 1 / 64.0
    static let padPlayLoopIndicatorRatio: CGFloat = 16.0
    static let padPlayLoopIndicatorInset: CGFloat = 10

    // Remove button
    static let removeButtonIcon = "cancel.png"
    static let removeButtonAlertTitle = "Confirm"
    static let removeButtonSampleTitle = "Remove sample"
    static let removeButtonAnimationTitle = "Remove animation"
    static let removeButtonBothTitle = "Remove both"
    static let removeButtonCancelTitle = "Cancel"

    // SidePane
    static let sidePaneWidth: CGFloat = 320
    static let sidePaneTabBarSampleIcon = "sound.png"
    static let sidePaneTabBarAnimationIcon = "params.png"

    // Group table
    static let groupTableA11yLabel = "Group Table"
    static let groupTableReuseIdentifier = "group"
    static let groupAlertTitle = "Group name"
    static let groupNameOkayTitle = "Okay"
    static let groupNameCancelTitle = "Cancel"

    // Sample table
    static let sampleTableA11yLabel = "Sample Table"
    static let sampleTableCellHeight: CGFloat = 60
    static let sampleTableTitle = "Samples"
    static let sampleTableReuseIdentifier = "sampleCell"
    static let sampleRemoveTitleFormat = "Remove %@?"
    static let sampleRemoveConfirmTitle = "Confirm"
    static let sampleRemoveCancelTitle = "Cancel"
    static let samplePlayButtonIcon = "play.png"

    // Animation table
    static let animationTableA11YLabel = "Animation Table"
    static let animationTableReuseIdentifier = "animationCell"
    static let animationEditActionTitle = "Edit"
    static let animationRemoveActionTitle = "Remove"
    static let animationEditAlertTitle = "Enter a new name"
    static let animationEditOkayTitle = "Okay"
    static let animationEditCancelTitle = "Cancel"
    static let animationRemoveTitleFormat = "Remove %@?"
    static let animationRemoveConfirmTitle = "Confirm"
    static let animationRemoveCancelTitle = "Cancel"
    static let animationTableCellHeight: CGFloat = Config.sampleTableCellHeight
    static let animationTabTitle = "Animations"

    // Bottom pane
    static let bottomPaneHeight = 220

    static let sampleSettingLoopLabel = "Loop"
    static let sampleSettingOnceOffLabel = "Once-off"

    // Page
    static let pageReuseIdentifier = "page"
    static let pageIconName = "padplay.png"
    static let pageSelectedIconName = "padplay_selected.png"

    // Animation Designer
    static let animationDesignItemOffset: CGFloat = 20
    static let animationDesignerPaneHeightOffset: CGFloat = -200
    static let timelineHeight: CGFloat = 48
    static let timelineNumSections = 1
    static let timelineBorderWidth: CGFloat = 5.0
    static let timelineBorderColour = UIColor.gray.cgColor
    static let timelineCornerRadiusRatio: CGFloat = 1 / 2.0
    static let colourPickerHeight: CGFloat = 60
    static let timelineTopOffset: CGFloat = 10
    static let colourPickerTopOffset: CGFloat = 10
    static let animationTypeControlTopOffset: CGFloat = 10
    static let clearSwitchLabelLeftOffset: CGFloat = 40
    static let clearSwitchLeftOffset: CGFloat = 10
    static let animationDesignTimelineLabel = "Animation Timeline"
    static let animationDesignColourLabel = "Colour Palette"
    static let animationDesignClearLabel = "Clear"
    static let animationDesignSaveLabel = "Save Animation"
    static let animationSaveAlertTitle = "Name for animation"
    static let animationSaveOkayTitle = "Save"
    static let animationSaveCancelTitle = "Cancel"

    // Timeline
    static let timelineA11yLabel = "Timeline"
    static let timelineMinNumFrames = 8
    static let timelineReuseIdentifier = "timeline"
    static let timelineInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    // ratio of height for unselected over selected frame in timeline
    static let timelineUnselectedFrameRatio: CGFloat = 0.7

    // Colour picker
    static let colourPickerA11yLabel = "Colour Picker"
    static let colourSelectionWidth: CGFloat = 3
    static let colourSelectionOffset: CGFloat = 5
    static let colourReuseIdentifier = "colour"
    static let colourInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    static let colourClearAnimImage = "clear_anim.png"

    // Session
    static let sessionTableA11yLabel = "Session Table"
    static let sessionTableTitle = "Sessions"
    static let sessionEditActionTitle = "Edit"
    static let sessionRemoveActionTitle = "Remove"
    static let sessionEditAlertTitle = "Enter a new name"
    static let sessionEditOkayTitle = "Okay"
    static let sessionEditCancelTitle = "Cancel"
    static let sessionRemoveTitleFormat = "Remove %@?"
    static let sessionRemoveConfirmTitle = "Confirm"
    static let sessionRemoveCancelTitle = "Cancel"
    static let sessionTableReuseIdentifier = "sessionCell"
    static let defaultSessionName = "New Session"

    // About / Tutorial
    static let tutorialImages = [
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

    static let audioFolderName = "samples"
    static let animationFileName = "animations"
    static let sessionFileName = "sessions"

    static let newAnimationTypeDefaultName = "Default Animation"

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
