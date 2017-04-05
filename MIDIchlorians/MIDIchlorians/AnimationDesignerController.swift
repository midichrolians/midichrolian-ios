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
    private var animationTypeSegmentedControl: UISegmentedControl!
    private var clearLabel: UILabel!
    private var clearSwitch: UISwitch!
    private var saveButton: UIButton!

    private var colourLabel: UILabel!

    private var timelineLabel: UILabel!
    internal var timeline: TimelineCollectionViewController!

    private var selectedColour: Colour? {
        didSet {
            colourPicker.selectedColour = selectedColour
            if let colour = selectedColour {
                delegate?.animationColour(selected: colour)
            }
        }
    }
    internal var frames: [Bool] = []
    internal var selectedFrame = 0

    override func viewDidLoad() {
        timelineLabel = UILabel()
        timelineLabel.text = "Animation timeline"
        timelineLabel.textColor = UIColor.white
        view.addSubview(timelineLabel)

        timeline = TimelineCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        timeline.timelineDelegate = self
        timeline.collectionView?.backgroundColor = UIColor.clear

        view.addSubview(timeline.view)

        animationTypeSegmentedControl = UISegmentedControl(items: AnimationTypeCreationMode.allValues())

        animationTypeSegmentedControl.selectedSegmentIndex = 0
        animationTypeSegmentedControl.tintColor = Config.FontPrimaryColor

        animationTypeSegmentedControl.addTarget(self, action: #selector(onAnimatedTypeChange), for: .valueChanged)

        view.addSubview(animationTypeSegmentedControl)

        colourLabel = UILabel()
        colourLabel.text = "Colour palette"
        colourLabel.textColor = UIColor.white
        view.addSubview(colourLabel)

        colourPicker = ColourPicker()
        colourPicker.backgroundColor = Config.BackgroundColor
        view.addSubview(colourPicker)

        clearLabel = UILabel()
        clearLabel.text = "Clear"
        clearLabel.textColor = UIColor.white
        view.addSubview(clearLabel)

        clearSwitch = UISwitch()
        clearSwitch.addTarget(self, action: #selector(clearSwitchToggle(clearSwitch:)), for: .valueChanged)
        view.addSubview(clearSwitch)

        saveButton = UIButton(type: .custom)
        saveButton.setTitle("Save Animation", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchDown)
        view.addSubview(saveButton)

        setConstraints()
        addGestures()
    }

    private func setConstraints() {
        timelineLabel.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.centerY.equalTo(timeline.view)
        }

        timeline.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(timelineLabel.snp.right).offset(20)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(Config.TimelineHeight)
            make.top.equalTo(view.snp.top)
        }

        colourLabel.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.centerY.equalTo(colourPicker)
            make.width.equalTo(timelineLabel)
        }

        colourPicker.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(colourLabel.snp.right).offset(20)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(Config.ColourPickerHeight)
            make.top.equalTo(timeline.view.snp.bottom).offset(Config.ColourPickerTopOffset)
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

        saveButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(clearSwitch.snp.right).offset(20)
            make.centerY.equalTo(clearSwitch)
            make.height.equalTo(clearSwitch)
        }
    }

    private func addGestures() {
        colourPicker.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(colourPickerTap(recognizer:))))
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

    func saveButtonTapped() {
        delegate?.saveAnimation()
    }
}

extension AnimationDesignerController: PadDelegate {
    func pad(animationUpdated animation: AnimationSequence) {
        frames = animation.animationBitsArray.map { ($0?.count ?? 0) > 0 }
    }
}

extension AnimationDesignerController: TimelineDelegate {
    internal var frame: [Bool] {
        return frames
    }

    internal var selectedIndex: Int {
        return selectedFrame
    }

    func timeline(selected: IndexPath) {
        selectedFrame = selected.row
        timeline.collectionView?.setNeedsLayout()
        timeline.collectionView?.reloadData()
        delegate?.animationTimeline(selected: selected.row)
    }

}
