//
//  AudioPlayer.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 28/2/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioManager {

    var validArray = Array(repeating: Array(repeating: false, count: 8), count: 8)
    var soundIDs = Array(repeating: Array(repeating: UInt32(0), count: 8), count: 8)
    init () {
        for i in 0 ... Config.sound.count - 1 {
            for j in 0 ... Config.sound[i].count - 1 {
                if let soundURL = Bundle.main.url(forResource: Config.sound[i][j], withExtension: "wav") {
                    var soundID = SystemSoundID(0)
                    AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
                    //send completed ID to notification center for UI update
                    AudioServicesAddSystemSoundCompletion(
                        soundID,
                        nil,
                        nil,
                        { (soundID, _) -> Void in
                            let nc = NotificationCenter.default
                            nc.post(
                                name:Notification.Name(rawValue:"Sound"),
                                object: nil,
                                userInfo: ["completed": soundID]
                            )
                        },
                        nil
                    )
                    soundIDs[i][j] = soundID
                    validArray[i][j] = true
                }
            }
        }
    }

    func play(indexPath: IndexPath) -> Bool {
        guard isValidSound(indexPath) else {
            return false
        }
        let row = indexPath.section
        let col = indexPath.item
        AudioServicesPlaySystemSound(soundIDs[row][col])

        return true
    }

    func isValidSound(_ indexPath: IndexPath) -> Bool {
        let row = indexPath.section
        let col = indexPath.item
        if Config.sound.count <= row || Config.sound[0].count <= col {
            return false
        }
        return validArray[indexPath.section][indexPath.item]
    }

    func getIndexPath(of soundID: UInt32) -> IndexPath {
        for row in 0 ... soundIDs.count - 1 {
            for col in 0 ... soundIDs[row].count - 1 {
                if soundID == soundIDs[row][col] {
                    return IndexPath(item: col, section: row)
                }
            }
        }
        return IndexPath(item: -1, section: -1)
    }
}
