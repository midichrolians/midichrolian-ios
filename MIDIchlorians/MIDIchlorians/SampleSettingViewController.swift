//
//  SampleSettingViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 6/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

class SampleSettingViewController: UIViewController {
    private var sampleSettingControl = UISegmentedControl()
    weak var delegate: SampleSettingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        sampleSettingControl = UISegmentedControl(items: SampleSettingMode.allValues())
        sampleSettingControl.selectedSegmentIndex = 0
        sampleSettingControl.addTarget(self, action: #selector(onSampleSettingModeChange), for: .valueChanged)

        view.addSubview(sampleSettingControl)
        setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setConstraints() {
        sampleSettingControl.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(view)
            make.height.equalTo(Config.TimelineHeight)
        }
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
}
