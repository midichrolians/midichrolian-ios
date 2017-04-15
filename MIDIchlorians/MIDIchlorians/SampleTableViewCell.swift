//
//  SampleTableViewCell.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

class SampleTableViewCell: UITableViewCell {
    var sampleName = UILabel()
    var playButton = UIButton()
    let playIcon = UIImage(named: Config.SamplePlayButtonIcon)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setUp()
        buildViewHierarchy()
        makeConstraints()
    }

    func setUp() {
        playButton.setImage(playIcon, for: .normal)
    }

    func buildViewHierarchy() {
        contentView.addSubview(playButton)
        contentView.addSubview(sampleName)
    }

    func makeConstraints() {
        playButton.snp.makeConstraints {(make) -> Void in
            make.left.top.height.equalTo(contentView)
            make.width.equalTo(playButton.snp.height)
        }

        sampleName.snp.makeConstraints { make in
            make.left.equalTo(playButton.snp.right).offset(10)
            make.top.right.height.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(sample: String) {
        self.sampleName.text = sample
    }

}
