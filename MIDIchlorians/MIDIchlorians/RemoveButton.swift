//
//  RemoveButton.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 5/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import SnapKit

// A remove button around pad with sample/animation assigned
class RemoveButton: SelectedPadTrackingView {
    let removeImage = UIImageView(image: UIImage(named: Config.RemoveButtonIcon))

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()
        buildViewHierarchy()
        makeConstraints()
    }

    func setUp() {
        isOpaque = false
        removeImage.accessibilityLabel = Config.RemoveButtonA11yLabel
    }

    func buildViewHierarchy() {
        self.addSubview(removeImage)
    }

    func makeConstraints() {
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
