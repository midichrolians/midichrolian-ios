//
//  Colour.swift
//  MIDIchlorians
//
//  Created by anands on 17/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

/// This enum represents the set of colours currently supported by the app
/// and is limited only by the number of image files created to give the effect of
/// physical buttons underlaid with LED lights

enum Colour: String, JSONable {
    case purple
    case lightBlue
    case blue
    case green
    case yellow
    case pink
    case red

    init(fromJSON: String) {
        guard let colour = Colour(rawValue: fromJSON) else {
            self = Colour.blue
            return
        }
        self = colour
    }

    var image: UIImage {
        var image: UIImage?
        switch self {
            case .purple:
                image = UIImage(named: Config.colourPurpleImageName)
            case .lightBlue:
                image = UIImage(named: Config.colourLightBlueImageName)
            case .blue:
                image = UIImage(named: Config.colourBlueImageName)
            case .green:
                image = UIImage(named: Config.colourGreenImageName)
            case .yellow:
                image = UIImage(named: Config.colourYellowImageName)
            case .pink:
                image = UIImage(named: Config.colourPinkImageName)
            case .red:
                image = UIImage(named: Config.colourRedImageName)
        }
        guard let imageToBeReturned = image else {
            return UIImage()
        }
        return imageToBeReturned
    }

    func getJSON() -> String? {
        return rawValue
    }

    static var allColours: [Colour] {
        return [.purple, .lightBlue, .blue, .green, .yellow, .pink, .red]
    }
}
