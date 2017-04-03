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
    var sampleName: UILabel!
    var playButton: UIButton!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        playButton = UIButton(frame: CGRect.zero)
        playButton.setImage(UIImage(named: "play.png"), for: .normal)
        contentView.addSubview(playButton)

        playButton.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(playButton.snp.height)
        }

        sampleName = UILabel(frame: CGRect.zero)
        contentView.addSubview(sampleName)

        sampleName.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(playButton.snp.right).offset(10)
            make.right.equalTo(contentView)
            make.height.equalTo(contentView)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(sample: String) {
        self.sampleName.text = sample
    }

}
