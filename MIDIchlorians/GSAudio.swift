//
//  GSAudio.swift
//  MIDIchlorians
//
//  Created by Ten Zhi yang on 8/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//
import Foundation
import AVFoundation

/**
 uses AVAudioPlayer, creates duplicate players to play (so that sound overlaps instead of abrubtly stopping)
 will do initializing on playSound and store the players in "players"
 will remove duplicate players after they finish playing
 */
class GSAudio: NSObject, AVAudioPlayerDelegate {

    static let sharedInstance = GSAudio()

    private override init() {}

    var players = [URL: AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()

    func playSound (audioDir: String) {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
                                                        return
        }
        let soundURL = docsURL.appendingPathComponent("\(audioDir)")
        let soundFileNameURL = soundURL

        if let player = players[soundFileNameURL] { //player for sound has been found

            if player.isPlaying == false { //player is not in use, so use that one
                player.prepareToPlay()
                player.play()

            } else { // player is in use, create a new, duplicate, player and use that instead
                do {
                    let duplicatePlayer = try AVAudioPlayer(contentsOf: soundFileNameURL)
                    //use 'try!' because we know the URL worked before.

                    duplicatePlayer.delegate = self
                    //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing

                    duplicatePlayers.append(duplicatePlayer)
                    //add duplicate to array so it doesn't get removed from memory before finishing

                    duplicatePlayer.prepareToPlay()
                    duplicatePlayer.play()
                } catch {
                    print("some error in GSPlayer")
                }
            }
        } else { //player has not been found, create a new player with the URL if possible
            do {
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.play()
            } catch {
                print("Could not play sound file!")
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        duplicatePlayers.remove(at: duplicatePlayers.index(of: player)!)
        //Remove the duplicate player once it is done
    }

}
