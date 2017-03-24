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

    var image: UIImageView {
        var imageView = UIImageView()
        switch self {
            case .violet:
                imageView = UIImageView(image: UIImage(named: "cesiousButton"))
            case .indigo:
                imageView = UIImageView(image: UIImage(named: "cyanButton"))
            case .blue:
                imageView = UIImageView(image: UIImage(named: "blueButton"))
            case .green:
                imageView = UIImageView(image: UIImage(named: "greenButton"))
            case .yellow:
                imageView = UIImageView(image: UIImage(named: "yellowButton"))
            case .orange:
                imageView = UIImageView(image: UIImage(named: "pinkButton"))
            case .red:
                imageView = UIImageView(image: UIImage(named: "redButton"))
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func getJSON() -> String {
        return rawValue
    }

    static var allColours: [Colour] {
        return [.violet, .indigo, .blue, .green, .yellow, .orange, .red]
    }
}
