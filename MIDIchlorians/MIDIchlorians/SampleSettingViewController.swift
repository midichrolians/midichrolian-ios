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
        sampleSettingControl.insertSegment(withTitle: "asdf", at: 0, animated: true)
        sampleSettingControl.insertSegment(withTitle: "hijkl", at: 0, animated: true)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
