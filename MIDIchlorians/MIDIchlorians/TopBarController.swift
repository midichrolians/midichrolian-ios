//
//  TopBarController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 23/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftyDropbox

// The top bar for the entire app.
// Handles the controls for selecting session, recording and playing, tutorial, sync.
class TopBarController: UIViewController {
    private var logoPic = UIImageView()
    private var logoImage = UIImage(named: Config.TopNavLogoIcon)!
    private var logo = UILabel()
    // used for managing the controls
    private var sessionTitle = UILabel()
    private var stackView = UIStackView()
    private var sessionButton = UIButton(type: .system)
    private var saveButton = UIButton(type: .system)
    private var editButton = UIButton(type: .system)
    private var recordButton = UIButton(type: .custom)
    private var playButton = UIButton(type: .system)
    private var syncButton = UIButton(type: .system)
    private var syncViewController = SyncViewController()
    private var hasRecording = false {
        didSet {
            playButton.isEnabled = hasRecording
        }
    }
    private var helpButton = UIButton(type: .system)

    private let recordImage = UIImage(named: Config.TopNavRecordIcon)!
    private let recordBlackImage = UIImage(named: Config.TopNavRecordingBlackIcon)!

    weak var modeSwitchDelegate: ModeSwitchDelegate?
    weak var sessionSelectorDelegate: SessionSelectorDelegate?
    weak var syncDelegate: SyncDelegate? {
        didSet {
            self.syncViewController.delegate = syncDelegate
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        buildViewHierarchy()
        setUp()
        setUpTargetAction()
        makeConstraints()
    }

    func setUp() {
        view.backgroundColor = Config.SecondaryBackgroundColor

        logoPic.image = logoImage
        logoPic.contentMode = .scaleAspectFit

        logo.text = Config.TopNavLogoText

        sessionTitle.text = Config.DefaultSessionName
        sessionTitle.accessibilityIdentifier = Config.TopNavSessionTitleA11yLabel

        sessionButton.setTitle(Config.TopNavSessionLabel, for: .normal)

        saveButton.setTitle(Config.TopNavSaveLabel, for: .normal)

        editButton.setTitle(Config.TopNavEditLabel, for: .normal)

        let loopingImage = UIImage.animatedImage(
            with: [recordImage, recordBlackImage],
            duration: Config.TopNavRecordingLoopDuration)
        recordButton.setBackgroundImage(recordImage, for: .normal)
        recordButton.setBackgroundImage(loopingImage, for: .selected)

        playButton.setTitle(Config.TopNavPlayLabel, for: .normal)
        // play button is always not enabled initially, user has to record something for it to be enabled
        playButton.isEnabled = false

        syncButton.setTitle(Config.TopNavSyncLabel, for: .normal)

        helpButton.setTitle(Config.TopNavHelpLabel, for: .normal)

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Config.TopNavStackViewSpacing
    }

    func buildViewHierarchy() {
        view.addSubview(logoPic)
        view.addSubview(logo)
        view.addSubview(sessionTitle)
        stackView.addArrangedSubview(sessionButton)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(syncButton)
        stackView.addArrangedSubview(helpButton)
        view.addSubview(stackView)
    }

    func setUpTargetAction() {
        editButton.addTarget(self, action: #selector(onEdit(_:)), for: .touchDown)
        recordButton.addTarget(self, action: #selector(onRecordButtonDown(sender:)), for: .touchDown)
        sessionButton.addTarget(self, action: #selector(sessionSelect(sender:)), for: .touchDown)
        playButton.addTarget(self, action: #selector(onPlayButtonDown(sender:)), for: .touchDown)
        syncButton.addTarget(self, action: #selector(sync(sender:)), for: .touchDown)
        helpButton.addTarget(self, action: #selector(logoTapped), for: .touchDown)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func makeConstraints() {
        logoPic.snp.makeConstraints { make in
            make.left.equalTo(view).offset(Config.AppLeftPadding)
            make.height.equalTo(view).inset(10)
            make.centerY.equalTo(view)
            make.width.equalTo(logoPic.snp.height)
        }

        logo.snp.makeConstraints { make in
            make.left.equalTo(logoPic.snp.right).offset(10)
            make.centerY.equalTo(view)
        }

        sessionTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.height.equalTo(view)
            make.width.lessThanOrEqualTo(Config.TopNavSessionNameMaxWidth)
        }

        stackView.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-Config.AppRightPadding)
            make.height.equalTo(view)
        }

        recordButton.snp.makeConstraints { make in
            make.width.equalTo(recordButton.snp.height)
            make.top.bottom.equalTo(view).inset(10)
        }

    }

    func setTargetActionOfSaveButton(target: AnyObject, selector: Selector) {
        saveButton.addTarget(target, action: selector, for: .touchDown)
    }

    // Called when the session selector is tapped
    func sessionSelect(sender: UIButton) {
        sessionSelectorDelegate?.sessionSelector(sender: sender)
    }

    func onEdit(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            // edit mode
            modeSwitchDelegate?.enterEdit()
            recordButton.isEnabled = false
            playButton.isEnabled = false
        } else {
            // exit edit more (entering play), restore record and play functionality
            modeSwitchDelegate?.enterPlay()
            recordButton.isEnabled = true
            playButton.isEnabled = true
        }
    }

    func onRecordButtonDown(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            startRecord()
        } else {
            stopRecord()
        }
    }

    func onPlayButtonDown(sender: UIButton) {
        if RecorderManager.instance.isPlaying {
            RecorderManager.instance.stopPlay()
        } else {
            RecorderManager.instance.startPlay()
        }
    }

    func startRecord() {
        RecorderManager.instance.startRecord()
    }

    func stopRecord() {
        RecorderManager.instance.stopRecord()
        // this will enable the play button
        hasRecording = true
    }

    func logoTapped() {
        let vc = TutorialViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }

    func sync(sender: UIButton) {
        syncViewController.modalPresentationStyle = .popover
        present(syncViewController, animated: true, completion: nil)

        // configure styles and anchor of popover presentation controller
        let popoverPresentationController = syncViewController.popoverPresentationController
        popoverPresentationController?.sourceView = sender
        popoverPresentationController?.sourceRect = sender.bounds
    }

    func setSession(to session: Session) {
        sessionTitle.text = session.getSessionName()
    }

}
