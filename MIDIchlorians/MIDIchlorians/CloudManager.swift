//
//  CloudManager.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 1/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import SwiftyDropbox

class CloudManager {

    static let instance = CloudManager()
    private let dataManager = DataManager.instance
    private var client: DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }

    private init() {
        //Just to ensure initialiser is private
    }

    func loadFromDropbox() {
        loadAudios()
        loadAnimations()
        loadSessions()
    }

    private func loadAudios() {

    }

    private func loadAnimations() {
    }

    private func loadSessions() {
    }

    func saveToDropbox() {
        saveAudios()
        saveAnimations()
        saveSessions()
    }

    private func saveAudios() {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
            return
        }
        //Get a list of samples
        let samples = dataManager.loadAllAudioStrings()
        //Upload each sample
        for sample in samples {
            let fileNameExtension = "\(sample).\(Config.SoundExt)"
            let filePath = "/\(Config.AudioFolderName)/\(fileNameExtension)"
            if fileExists(filePath) {
                continue
            }
            let url = docsURL.appendingPathComponent("\(sample).\(Config.SoundExt)")
            client?.files.upload(path: filePath, input: url)
        }
    }

    private func saveAnimations() {
        let animationJSONs = dataManager.loadAllAnimationTypes().map { ($0, $0.data(using: .utf8)) }
        for animation in animationJSONs {
            guard let data = animation.1 else {
                continue
            }
            let fileNameExtension = "\(animation.0).\(Config.AnimationExt)"
            let filePath = "/\(Config.AnimationFolderName)/\(fileNameExtension)"
            if fileExists(filePath) {
                continue
            }
            client?.files.upload(path: filePath, input: data)
        }

    }

    private func saveSessions() {
        let sessions = dataManager.loadAllSessionNames().flatMap { dataManager.loadSession($0) }
        let sessionJSONs = sessions.map(($0, $0.serialise()))
        for session in sessionJSONs {
            guard let data = session.1 else {
                continue
            }
            let fileNameExtension = "\(session.0).\(Config.SessionExt)"
            let filePath = "/\(Config.SessionsFolderName)/\(fileNameExtension)"
            if fileExists(filePath) {
                continue
            }
            client?.files.upload(path: filePath, input: data)
        }

    }

    private func fileExists(_ filePath: String) -> Bool {
        return false
    }
}
