//
//  AnimationDesignerController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 29/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

class AnimationDesignerController: UIViewController {
    weak var delegate: AnimationDesignerDelegate?

    // require animation data
    private var colourPicker: ColourPicker!
    private var timelineView: TimelineView!
    private var animationTypeSegmentedControl: UISegmentedControl!
    private var clearLabel: UILabel!
    private var clearSwitch: UISwitch!

    private var tapGesture: UITapGestureRecognizer?
    private var selectedColour: Colour? {
        didSet {
            colourPicker.selectedColour = selectedColour
            if let colour = selectedColour {
                delegate?.animationColour(selected: colour)
            }
        }
    }

    override func viewDidLoad() {
        animationTypeSegmentedControl = UISegmentedControl(items: AnimationTypeCreationMode.allValues())

        animationTypeSegmentedControl.selectedSegmentIndex = 0
        animationTypeSegmentedControl.tintColor = Config.FontPrimaryColor

        animationTypeSegmentedControl.addTarget(self, action: #selector(onAnimatedTypeChange), for: .valueChanged)

        view.addSubview(animationTypeSegmentedControl)

        colourPicker = ColourPicker()
        colourPicker.backgroundColor = Config.BackgroundColor
        view.addSubview(colourPicker)

        timelineView = TimelineView()
        timelineView.backgroundColor = Config.BackgroundColor
        view.addSubview(timelineView)

        clearLabel = UILabel()
        clearLabel.text = "Clear"
        clearLabel.textColor = UIColor.white
        view.addSubview(clearLabel)

        clearSwitch = UISwitch()
        clearSwitch.addTarget(self, action: #selector(clearSwitchToggle(clearSwitch:)), for: .valueChanged)
        view.addSubview(clearSwitch)

        setConstraints()
        addGestures()
    }

    private func setConstraints() {
        timelineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(Config.TimelineHeight)
            make.top.equalTo(view.snp.top).offset(Config.TimelineTopOffset)
        }

        colourPicker.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)

            make.height.equalTo(Config.ColourPickerHeight)
            make.top.equalTo(timelineView.snp.bottom).offset(Config.ColourPickerTopOffset)
        }

        animationTypeSegmentedControl.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.top.equalTo(colourPicker.snp.bottom).offset(Config.AnimationTypeControlTopOffset)
        }

        clearLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(animationTypeSegmentedControl.snp.right).offset(Config.ClearSwitchLabelLeftOffset)
            make.centerY.equalTo(animationTypeSegmentedControl)
        }

        clearSwitch.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(clearLabel.snp.right).offset(Config.ClearSwitchLeftOffset)
            make.centerY.equalTo(clearLabel)
        }
    }

    private func addGestures() {
        timelineView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(timelineTap(recognizer:))))

        colourPicker.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(colourPickerTap(recognizer:))))
    }

    func timelineTap(recognizer: UITapGestureRecognizer) {
        let loc = recognizer.location(in: timelineView)
        if let frameIndex = timelineView.frameIndex(at: loc) {
            delegate?.animationTimeline(selected: frameIndex)
        }
    }

    func colourPickerTap(recognizer: UITapGestureRecognizer) {
        let loc = recognizer.location(in: colourPicker)
        if let colour = colourPicker.colour(at: loc) {
            // reset the clear switch
            clearSwitch.setOn(false, animated: true)
            selectedColour = colour
        }
    }

    func onAnimatedTypeChange() {
        guard let selectedAnimatedTypeName = self.animationTypeSegmentedControl.titleForSegment(
            at: self.animationTypeSegmentedControl.selectedSegmentIndex
            ) else {
                return
        }
        guard let mode = AnimationTypeCreationMode(rawValue: selectedAnimatedTypeName) else {
            return
        }
        delegate?.animationTypeCreationMode(
            selected: mode
        )
    }

    func clearSwitchToggle(clearSwitch: UISwitch) {
        if clearSwitch.isOn {
            delegate?.animationClear()
        }
    }
}
