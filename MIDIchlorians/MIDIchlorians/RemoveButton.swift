//
//  RemoveButton.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

class RemoveButton: SelectedPadTrackingView {
    let removeImage = UIImageView(image: UIImage(named: "cancel.png"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        self.addSubview(removeImage)
        removeImage.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func calculateOffset(relativeTo cell: UICollectionViewCell) -> CGRect {
        return CGRect(x: cell.frame.minX - Config.RemoveButtonOffset,
                      y: cell.frame.minY - Config.RemoveButtonOffset,
                      width: Config.RemoveButtonWidth,
                      height: Config.RemoveButtonWidth)
    }

}
