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

    override func viewDidLoad() {
        super.viewDidLoad()
        sampleSettingControl.insertSegment(withTitle: Config.SampleSettingLoopLabel, at: 0, animated: true)
        sampleSettingControl.insertSegment(withTitle: Config.SampleSettingOnceOffLabel, at: 0, animated: true)
        sampleSettingControl.selectedSegmentIndex = 0

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

}
