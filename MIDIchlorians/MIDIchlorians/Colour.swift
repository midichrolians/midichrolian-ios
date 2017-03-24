//
//  Colour.swift
//  MIDIchlorians
//
//  Created by anands on 17/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit

enum Colour: String {
    case violet
    case indigo
    case blue
    case green
    case yellow
    case orange
    case red

    init(colourName: String) {
        guard let colour = Colour(rawValue: colourName) else {
            self = Colour.blue
            return
        }
        self = colour
    }

    var uiColor: UIColor {
        switch self {
            case .violet:
                return UIColor.violet
            case .indigo:
                return UIColor.indigo
            case .blue:
                return UIColor.blue
            case .green:
                return UIColor.green
            case .yellow:
                return UIColor.yellow
            case .orange:
                return UIColor.orange
            case .red:
                return UIColor.red
        }
    }

    var image: UIImage {
        var image: UIImage?
        switch self {
            case .violet:
                image = UIImage(named: "cesiousButton")
            case .indigo:
                image = UIImage(named: "cyanButton")
            case .blue:
                image = UIImage(named: "blueButton")
            case .green:
                image = UIImage(named: "greenButton")
            case .yellow:
                image = UIImage(named: "yellowButton")
            case .orange:
                image = UIImage(named: "pinkButton")
            case .red:
                image = UIImage(named: "redButton")
        }
        guard let imageToBeReturned = image else {
            return UIImage()
        }
        return imageToBeReturned
    }

    func getJSON() -> String {
        return rawValue
    }

    static var allColours: [Colour] {
        return [.violet, .indigo, .blue, .green, .yellow, .orange, .red]
    }
}
