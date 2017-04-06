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

    weak var modeSwitchDelegate: ModeSwitchDelegate?
    weak var sessionSelectorDelegate: SessionSelectorDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)

        logo.text = "MIDIchlorians"
        view.addSubview(logo)
        view.backgroundColor = UIColor.white

        sessionButton.setTitle("Sessions", for: .normal)
        sessionButton.tintColor = UIColor.black
        sessionButton.addTarget(self, action: #selector(sessionSelect(sender:)), for: .touchDown)
        view.addSubview(sessionButton)

        saveButton.setTitle("Save", for: .normal)

        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(onEdit), for: .touchDown)

        exitButton.setTitle("Exit", for: .normal)
        exitButton.addTarget(self, action: #selector(onExit), for: .touchDown)

        stackView.addArrangedSubview(sessionButton)
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(saveButton)
        stackView.axis = .horizontal
        stackView.spacing = 20
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
        stackView.removeArrangedSubview(exitButton)
        exitButton.removeFromSuperview()
        stackView.insertArrangedSubview(editButton, at: 0)
    }

    func onEdit() {
        modeSwitchDelegate?.enterEdit()
        stackView.removeArrangedSubview(editButton)
        editButton.removeFromSuperview()
        stackView.insertArrangedSubview(exitButton, at: 0)
    }

}
