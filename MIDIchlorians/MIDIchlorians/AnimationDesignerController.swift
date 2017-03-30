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
    // require animation data
    var colourPicker: ColourPicker!
    var timelineView: TimelineView!
    var animationTypeSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        animationTypeSegmentedControl = UISegmentedControl(items: ["absolute", "relative"])

        animationTypeSegmentedControl.selectedSegmentIndex = 0
        animationTypeSegmentedControl.tintColor = Config.FontPrimaryColor

        view.addSubview(animationTypeSegmentedControl)

        colourPicker = ColourPicker()
        view.addSubview(colourPicker)

        timelineView = TimelineView()
        view.addSubview(timelineView)

        setConstraints()
    }

    func setConstraints() {
        timelineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(60)
            make.top.equalTo(view.snp.top).offset(10)
        }

        colourPicker.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)

            make.height.equalTo(60)
            make.top.equalTo(timelineView.snp.bottom).offset(10)
        }

        animationTypeSegmentedControl.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.top.equalTo(colourPicker.snp.bottom).offset(10)
        }
    }

}
