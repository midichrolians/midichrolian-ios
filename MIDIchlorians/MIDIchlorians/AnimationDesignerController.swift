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
    private var animationTypeSegmentedControl: UISegmentedControl!
    private var clearLabel: UILabel!
    internal var clearSwitch: UISwitch!
    private var saveButton: UIButton!

    private var colourLabel: UILabel!
    internal var colourPicker: ColourCollectionViewController!
    internal var colourSelection = ColourSelection()

    private var timelineLabel: UILabel!
    internal var timeline: TimelineCollectionViewController!

    internal var selectedColour: Colour?

    internal var frames: [Bool] = []
    internal var selectedFrame = IndexPath(row: 0, section: 0)

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

        colourPicker = ColourCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        colourPicker.colourDelegate = self
        colourPicker.collectionView?.backgroundColor = UIColor.clear
        view.addSubview(colourPicker.view)

        colourSelection.viewController = colourPicker
        colourPicker.view.insertSubview(colourSelection, belowSubview: colourPicker.collectionView!)
        // view.insertSubview(colourSelection, belowSubview: colourPicker.view)
        colourSelection.position(at: nil)

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
            make.centerY.equalTo(colourPicker.view)
            make.width.equalTo(timelineLabel)
        }

        colourPicker.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(colourLabel.snp.right).offset(20)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(Config.ColourPickerHeight)
            make.top.equalTo(timeline.view.snp.bottom).offset(Config.ColourPickerTopOffset)
        }

        animationTypeSegmentedControl.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.top.equalTo(colourPicker.view.snp.bottom).offset(Config.AnimationTypeControlTopOffset)
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
            // clear switch turned on, inform delegate
            delegate?.animationClear()
            // and also clear selected colour in palette to visually indicate
            selectedColour = nil
            colourSelection.position(at: nil)
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

    func timeline(selected: IndexPath) {
        selectedFrame = selected
        timeline.collectionView?.setNeedsLayout()
        timeline.collectionView?.reloadData()
        delegate?.animationTimeline(selected: selected.row)
    }
}

extension AnimationDesignerController: ColourPickerDelegate {
    var colours: [Colour] {
        return Colour.allColours
    }

    func colour(selected colour: Colour, indexPath: IndexPath) {
        delegate?.animationColour(selected: colour)
        selectedColour = colour
        colourPicker.collectionView?.reloadData()
        colourSelection.position(at: indexPath)
        clearSwitch.setOn(false, animated: true)
    }
}
