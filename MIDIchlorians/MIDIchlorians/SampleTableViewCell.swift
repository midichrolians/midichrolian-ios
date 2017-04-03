//
//  SampleTableViewCell.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class SampleTableViewCell: UITableViewCell {
    var playButton: UIButton!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        imageView?.image = UIImage(named: "play.png")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(sample: String) {
        self.textLabel?.text = sample
    }

}
