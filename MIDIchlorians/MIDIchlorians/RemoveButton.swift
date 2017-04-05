//
//  RemoveButton.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

class RemoveButton: SelectedPadTrackingView {
    var button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = UIColor.blue
        layer.cornerRadius = 5.0

        button.setTitle("X", for: .normal)
        self.addSubview(button)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func calculateOffset(relativeTo cell: UICollectionViewCell) -> CGRect {
        // This selection should look like a border around the cell
        // need to offset the frame by some pixels, increase the width
        let offset: CGFloat = 10
        return CGRect(x: cell.frame.minX - offset,
                      y: cell.frame.minY - offset,
                      width: cell.frame.width * 1 / 3,
                      height: cell.frame.height * 1 / 3)
    }

}
