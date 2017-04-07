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
    private let offset: CGFloat = Config.AnimationDesignItemOffset

    private var animationTypeSegmentedControl: UISegmentedControl!
    private var saveButton: UIButton!
    internal var saveAlert: UIAlertController!

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
        timelineLabel.text = Config.AnimationDesignTimelineLabel
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
        colourLabel.text = Config.AnimationDesignColourLabel
        view.addSubview(colourLabel)

        colourPicker = ColourCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        colourPicker.colourDelegate = self
        colourPicker.collectionView?.backgroundColor = UIColor.clear
        view.addSubview(colourPicker.view)

        colourSelection.viewController = colourPicker
        colourPicker.view.insertSubview(colourSelection, belowSubview: colourPicker.collectionView!)
        colourSelection.position(at: nil)

        saveButton = UIButton(type: .system)
        saveButton.setTitle(Config.AnimationDesignSaveLabel, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchDown)
        view.addSubview(saveButton)

        saveAlert = UIAlertController(title: Config.AnimationSaveAlertTitle, message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: Config.AnimationSaveOkayTitle, style: .default, handler: saveActionDone)
        saveAction.isEnabled = false
        saveAlert.addAction(saveAction)
        saveAlert.addAction(UIAlertAction(title: Config.AnimationSaveCancelTitle, style: .cancel, handler: nil))
        saveAlert.addTextField(configurationHandler: { $0.delegate = self })

        setConstraints()
    }

    private func setConstraints() {
        timelineLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(offset)
            make.centerY.equalTo(timeline.view)
        }

        timeline.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(timelineLabel.snp.right).offset(offset)
            make.right.equalTo(view)
            make.height.equalTo(Config.TimelineHeight)
            make.top.equalTo(view.snp.top).offset(offset)
        }

        colourLabel.snp.makeConstraints { make in
            make.left.equalTo(timelineLabel)
            make.centerY.equalTo(colourPicker.view)
            make.width.equalTo(timelineLabel)
        }

        colourPicker.view.snp.makeConstraints { make in
            make.left.equalTo(timeline.view)
            make.right.equalTo(view)
            make.height.equalTo(Config.ColourPickerHeight)
            make.top.equalTo(timeline.view.snp.bottom).offset(Config.ColourPickerTopOffset)
        }

        animationTypeSegmentedControl.snp.makeConstraints { make in
            make.left.equalTo(colourLabel)
            make.top.equalTo(colourPicker.view.snp.bottom).offset(Config.AnimationTypeControlTopOffset)
            make.height.equalTo(Config.TimelineHeight)
        }

        saveButton.snp.makeConstraints { make in
            make.left.equalTo(animationTypeSegmentedControl.snp.right).offset(offset)
            make.centerY.height.equalTo(animationTypeSegmentedControl)
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

    func saveButtonTapped() {
        self.present(saveAlert, animated: true, completion: nil)
    }

    func saveActionDone(_: UIAlertAction) {
        guard let newName = self.saveAlert.textFields?.first?.text else {
            return
        }
        if newName.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            return
        }
        self.delegate?.saveAnimation(name: newName)
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
    }

    func clear(indexPath: IndexPath) {
        delegate?.animationClear()
        // and also clear selected colour in palette to visually indicate
        selectedColour = nil
        colourSelection.position(at: indexPath)
    }
}

extension AnimationDesignerController: UITextFieldDelegate {
    // Don't allow return if the field is empty, user must explicitly cancel
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return !(textField.text?.isEmpty ?? true)
    }

    // Deactivate the Save button if text field is empty
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }

        let str = (text as NSString).replacingCharacters(in: range, with: string)
        if str.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            saveAlert.actions.first?.isEnabled = false
        } else {
            saveAlert.actions.first?.isEnabled = true
        }
        return true
    }
}
