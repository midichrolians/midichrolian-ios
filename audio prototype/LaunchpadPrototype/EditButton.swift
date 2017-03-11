//
//  EditButton.swift
//  LaunchpadPrototype
//
//  Created by Zhi An Ng on 10/3/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import UIKit
import Foundation

protocol EditButtonDelegate {
    func editStart()
    func editEnd()
}

class EditButton: NSObject {
    private weak var superview: UIView?
    private var view: UIButton
    private var delegate: EditButtonDelegate

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
        if (view.isSelected) {
            delegate.editStart()
        } else {
            delegate.editEnd()
        }
    }
}
