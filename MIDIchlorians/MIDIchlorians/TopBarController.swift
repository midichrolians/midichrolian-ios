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

class TopBarController: UIViewController {
    private var logo = UILabel()
    // used for managing the controls
    private var stackView = UIStackView()
    private var sessionButton = UIButton(type: .system)
    private var saveButton = UIButton(type: .system)
    private var editButton = UIButton(type: .system)
    private var exitButton = UIButton(type: .system)
    private var recordButton = UIButton(type: .system)
    private var recordIndicator = UIImageView()

    private let recordImage = UIImage(named: Config.TopNavRecordIcon)
    private let recordingImage = UIImage(named: Config.TopNavRecordingIcon)

    weak var modeSwitchDelegate: ModeSwitchDelegate?
    weak var sessionSelectorDelegate: SessionSelectorDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Config.SecondaryBackgroundColor

        logo.text = Config.TopNavLogoText
        logo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoTapped)))
        logo.isUserInteractionEnabled = true
        view.addSubview(logo)

        sessionButton.setTitle(Config.TopNavSessionLabel, for: .normal)
        sessionButton.tintColor = UIColor.black
        sessionButton.addTarget(self, action: #selector(sessionSelect(sender:)), for: .touchDown)

        saveButton.setTitle(Config.TopNavSaveLabel, for: .normal)

        editButton.setTitle(Config.TopNavEditLabel, for: .normal)
        editButton.addTarget(self, action: #selector(onEdit), for: .touchDown)

        exitButton.setTitle(Config.TopNavExitLabel, for: .normal)
        exitButton.addTarget(self, action: #selector(onExit), for: .touchDown)

        recordButton.setTitle(Config.TopNavRecordLabel, for: .normal)
        recordButton.addTarget(self, action: #selector(onRecordButtonDown(sender:)), for: .touchDown)

        recordIndicator.image = recordImage

        stackView.addArrangedSubview(sessionButton)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(recordIndicator)
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
        }

        stackView.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-Config.AppRightPadding)
            make.height.equalTo(view)
        }

        recordIndicator.snp.makeConstraints { make in
            make.width.equalTo(recordIndicator.snp.height)
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
        replace(stackView: stackView, rep: exitButton, with: editButton)
    }

    func onEdit() {
        modeSwitchDelegate?.enterEdit()
        replace(stackView: stackView, rep: editButton, with: exitButton)
    }

    func onRecordButtonDown(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            startRecord()
        } else {
            stopRecord()
        }
    }

    func startRecord() {
        recordIndicator.image = recordingImage
    }

    func stopRecord() {
            recordIndicator.image = recordImage
    }

    func logoTapped() {
        let vc = AboutUsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        vc.view.backgroundColor = UIColor.blue
    }

    func replace(stackView: UIStackView, rep: UIView, with: UIView) {
        guard let index = stackView.arrangedSubviews.index(of: rep) else {
            return
        }
        stackView.insertArrangedSubview(with, at: index)
        stackView.removeArrangedSubview(rep)
        rep.removeFromSuperview()
    }

}
