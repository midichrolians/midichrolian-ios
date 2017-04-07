//
//  UIStackView+Extensions.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 6/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

extension UIStackView {
    // Replaces view with another view in the stack view
    func replace(view: UIView, with: UIView) {
        guard let index = arrangedSubviews.index(of: view) else {
            return
        }
        insertArrangedSubview(with, at: index)
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

}
