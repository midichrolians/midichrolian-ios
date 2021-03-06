//
//  BPMViewController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 10/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

// Manages the control that displays the current BPM for the session, and allows a user to change it.
class BPMViewController: UIViewController {
    var bpmPicker = UIPickerView()
    var selectedBPM: Int = Config.topNavBPMDefaultBPM
    var bpmListener: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        bpmPicker.dataSource = self
        bpmPicker.delegate = self
        bpmPicker.selectRow(selectedBPM - Config.topNavBPMMinBPM, inComponent: 0, animated: false)
        view.addSubview(bpmPicker)

        preferredContentSize = CGSize(width: Config.topNavBPMPreferredWidth,
                                      height: Config.topNavBPMPreferredHeight)

        setConstraints()
    }

    func setConstraints() {
        bpmPicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BPMViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Config.topNavBPMMaxBPM - Config.topNavBPMMinBPM + 1
    }
}

extension BPMViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(Config.topNavBPMMinBPM + row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBPM = Config.topNavBPMMinBPM + row
        bpmListener?(selectedBPM)
    }
}
