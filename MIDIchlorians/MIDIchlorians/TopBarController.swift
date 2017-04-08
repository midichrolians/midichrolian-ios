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
    private var stackView = UIStackView()
    private var sessionButton = UIButton(type: .system)
    private var saveButton = UIButton(type: .system)
    private var editButton = UIButton(type: .system)
    private var exitButton = UIButton(type: .system)
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

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Config.SecondaryBackgroundColor

        logo.setTitle(Config.TopNavLogoText, for: .normal)
        logo.addTarget(self, action: #selector(logoTapped), for: .touchDown)
        view.addSubview(logo)

        sessionButton.setTitle(Config.TopNavSessionLabel, for: .normal)
        sessionButton.addTarget(self, action: #selector(sessionSelect(sender:)), for: .touchDown)

        saveButton.setTitle(Config.TopNavSaveLabel, for: .normal)

        editButton.setTitle(Config.TopNavEditLabel, for: .normal)
        editButton.addTarget(self, action: #selector(onEdit), for: .touchDown)

        exitButton.setTitle(Config.TopNavExitLabel, for: .normal)
        exitButton.addTarget(self, action: #selector(onExit), for: .touchDown)

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

    func onExit() {
        modeSwitchDelegate?.enterPlay()
        stackView.replace(view: exitButton, with: editButton)

        // exit edit more (entering play), restore record and play functionality
        recordButton.isHidden = false
        playButton.isHidden = false
    }

    func onEdit() {
        modeSwitchDelegate?.enterEdit()
        stackView.replace(view: editButton, with: exitButton)

        // entering edit mode, so hide functionality to record and play
        recordButton.isHidden = true
        playButton.isHidden = true
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
    }

    func startRecord() {
    }

    func stopRecord() {
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
//
        // configure styles and anchor of popover presentation controller
        let popoverPresentationController = syncViewController.popoverPresentationController
        popoverPresentationController?.sourceView = sender
        popoverPresentationController?.sourceRect = sender.bounds
        popoverPresentationController?.popoverLayoutMargins = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
    }

}
