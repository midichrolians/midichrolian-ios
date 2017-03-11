//
//  CGSize+Extensions.swift
//  LaunchpadPrototype
//
//  Created by Zhi An Ng on 10/3/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import CoreGraphics
import Foundation

extension CGSize {
    public func scale(by factor: CGFloat) -> CGSize {
        return CGSize(width: self.width * factor, height: self.height * factor)
    }
    
}
