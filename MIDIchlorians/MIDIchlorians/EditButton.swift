//
//  EditButton.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import Foundation

// Adopt this protocol to react when entering or exiting edit mode.
protocol EditButtonDelegate: class {
    func editStart()
    func editEnd()
}

// Button used to enter/exit editing mode.
class EditButton: NSObject {
    private weak var superview: UIView?
    private var view: UIButton
    private weak var delegate: EditButtonDelegate?

    // create a view for the edit button
    init(superview: UIView, delegate: EditButtonDelegate) {
        self.superview = superview
        self.delegate = delegate
        view = UIButton()
        super.init()

        view.backgroundColor = UIColor.red
        view.setTitle("EDIT", for: .normal)
        view.setTitle("EDITING", for: .selected)
        view.frame = CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 100, height: 32))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(edit)))
        superview.addSubview(self.view)
    }

    func edit() {
        view.isSelected = !view.isSelected
        if view.isSelected {
            delegate?.editStart()
        } else {
            delegate?.editEnd()
        }
    }
}
