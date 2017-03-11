//
//  EditPaneController.swift
//  MIDIchlorians
//
//  Created by Zhi An Ng on 11/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import Foundation
import UIKit

class EditPane: NSObject {
    weak var superview: UIView?
    var view: UIView

    init(superview: UIView) {
        self.superview = superview
        // TODO remove constant
        let baseWidth = (self.superview?.frame.width ?? 100) * 0.25
        let x = (self.superview?.frame.width ?? 100) - 20 - baseWidth
        self.view = UIView(frame: CGRect(
            origin: CGPoint(x: x, y: 90),
            size: CGSize(width: baseWidth, height: 500)))
        let tabBar = UITabBar(frame: CGRect(x: 0, y: 0, width: baseWidth, height: 50))
        tabBar.items = [
            UITabBarItem(title: "Sessions", image: nil, selectedImage: nil),
            UITabBarItem(title: "Samples", image: nil, selectedImage: nil)
        ]
        self.view.isHidden = true
        self.view.addSubview(tabBar)
        superview.addSubview(self.view)
        super.init()
    }
}
