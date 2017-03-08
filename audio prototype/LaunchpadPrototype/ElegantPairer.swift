//
//  ElegantPairer.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 4/3/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import Foundation
import Darwin

struct ElegantPairer {
    static func pair(x: Int, y: Int) -> Int {
        return (x >= y) ? (x * x + x + y) : (y * y + x)
    }
    
    static func elegantUnpair(z: Int) -> (x: Int, y: Int) {
    let sqrtz = Int(floor(sqrt(Double(z))))
    let sqz = sqrtz * sqrtz;
    return ((z - sqz) >= sqrtz) ? (sqrtz, z - sqz - sqrtz) : (z - sqz, sqrtz)
    }
}
