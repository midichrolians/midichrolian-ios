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

class TopBarController: UIViewController {
    private var logo = UIButton(type: .system)
    // used for managing the controls
    private var sessionTitle = UILabel()
    private var stackView = UIStackView()
    private var sessionButton = UIButton(type: .system)
    private var bpmSelector = UIButton(type: .system)
    private var bpmVC = BPMViewController()
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

    private let recordImage = UIImage(named: Config.TopNavRecordIcon)!
    private let recordBlackImage = UIImage(named: Config.TopNavRecordingBlackIcon)!

    weak var modeSwitchDelegate: ModeSwitchDelegate?
    weak var sessionSelectorDelegate: SessionSelectorDelegate?
    weak var syncDelegate: SyncDelegate? {
        didSet {
            self.syncViewController.delegate = syncDelegate
        }
    }
    weak var bpmSelectorDelegate: BPMSelectorDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Config.SecondaryBackgroundColor

        logo.setTitle(Config.TopNavLogoText, for: .normal)
        logo.addTarget(self, action: #selector(logoTapped), for: .touchDown)
        view.addSubview(logo)

        sessionTitle.text = Config.DefaultSessionName
        view.addSubview(sessionTitle)

        sessionButton.setTitle(Config.TopNavSessionLabel, for: .normal)
        sessionButton.addTarget(self, action: #selector(sessionSelect(sender:)), for: .touchDown)

        bpmSelector.setTitle(String.init(format: Config.TopNavBPMTitleFormat, Config.TopNavBPMDefaultBPM), for: .normal)
        bpmSelector.addTarget(self, action: #selector(bpmSelect(sender:)), for: .touchDown)
        bpmVC.selectedBPM = Config.TopNavBPMDefaultBPM

        saveButton.setTitle(Config.TopNavSaveLabel, for: .normal)

        editButton.setTitle(Config.TopNavEditLabel, for: .normal)
        editButton.addTarget(self, action: #selector(onEdit(_:)), for: .touchDown)

        let loopingImage = UIImage.animatedImage(
            with: [recordImage, recordBlackImage],
            duration: Config.TopNavRecordingLoopDuration)
        recordButton.setBackgroundImage(recordImage, for: .normal)
        recordButton.setBackgroundImage(loopingImage, for: .selected)
        recordButton.addTarget(self, action: #selector(onRecordButtonDown(sender:)), for: .touchDown)

        playButton.setTitle(Config.TopNavPlayLabel, for: .normal)
        playButton.addTarget(self, action: #selector(onPlayButtonDown(sender:)), for: .touchDown)
        // play button is always not enabled initially, user has to record something for it to be enabled
        playButton.isEnabled = false

        syncButton.setTitle(Config.TopNavSyncLabel, for: .normal)
        syncButton.addTarget(self, action: #selector(sync(sender:)), for: .touchDown)

        stackView.addArrangedSubview(sessionButton)
        stackView.addArrangedSubview(bpmSelector)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(syncButton)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Config.TopNavStackViewSpacing
        view.addSubview(stackView)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func makeConstraints() {
        logo.snp.makeConstraints { make in
            make.left.equalTo(view).offset(Config.AppLeftPadding)
            make.height.equalTo(view)
            make.centerY.equalTo(view)
        }

        sessionTitle.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
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

    // Called when bpm selector is tapped
    func bpmSelect(sender: UIButton) {
        // present a UIPickerView as a popover
        bpmVC.modalPresentationStyle = .popover
        bpmVC.bpmListener = bpmListener
        present(bpmVC, animated: true, completion: nil)
        let popover = bpmVC.popoverPresentationController
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
    }

    func bpmListener(bpm: Int) {
        bpmSelector.setTitle(String.init(format: Config.TopNavBPMTitleFormat, bpm), for: .normal)
        bpmSelectorDelegate?.bpm(selected: bpm)
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
        let vc = AboutUsViewController()
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
