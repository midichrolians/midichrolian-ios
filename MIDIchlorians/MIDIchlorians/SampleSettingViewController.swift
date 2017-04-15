//
//  SampleSettingViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 6/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

// Manages the control to configure a sample assigned to a pad.
// Supports one-off and loop.
class SampleSettingViewController: UIViewController {
    private var sampleSettingControl = UISegmentedControl(items: SampleSettingMode.allValues())
    weak var delegate: SampleSettingDelegate?
    private var bpmSelector = UIButton(type: .system)
    private var bpmVC = BPMViewController()
    weak var bpmSelectorDelegate: BPMSelectorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        buildViewHierarchy()
        buildConstraints()
        addTargetAction()
    }

    func setUp() {
        sampleSettingControl.selectedSegmentIndex = 0
        bpmSelector.setTitle(String.init(format: Config.TopNavBPMTitleFormat, Config.TopNavBPMDefaultBPM), for: .normal)
        bpmVC.selectedBPM = Config.TopNavBPMDefaultBPM
    }

    func buildViewHierarchy() {
        view.addSubview(sampleSettingControl)
        view.addSubview(bpmSelector)
    }

    func buildConstraints() {
        sampleSettingControl.snp.makeConstraints { make in
            make.left.top.equalTo(view).offset(Config.AppLeftPadding)
            make.height.equalTo(Config.TimelineHeight)
        }

        bpmSelector.snp.makeConstraints { make in
            make.left.height.equalTo(sampleSettingControl)
            make.top.equalTo(sampleSettingControl.snp.bottom).offset(10)
        }
    }

    func addTargetAction() {
        sampleSettingControl.addTarget(self, action: #selector(onSampleSettingModeChange), for: .valueChanged)
        bpmSelector.addTarget(self, action: #selector(bpmSelect(sender:)), for: .touchDown)
    }

    func onSampleSettingModeChange() {
        guard let selectedSampleSettingModeName = self.sampleSettingControl.titleForSegment(
            at: self.sampleSettingControl.selectedSegmentIndex
            ) else {
                return
        }
        guard let mode = SampleSettingMode(rawValue: selectedSampleSettingModeName) else {
            return
        }
        delegate?.sampleSettingMode(
            selected: mode
        )
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

}
