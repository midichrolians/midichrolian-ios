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
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
           return
        }
        client?.files.listFolder(path: "/\(Config.AudioFolderName)/").response { response, _ in
            guard let result = response else {
                return
            }
            for sample in result.entries {
                guard self.isSoundFile(sample.name) else {
                    continue
                }
                let filePath = "/\(Config.AudioFolderName)/\(sample.name)"
                let url = docsURL.appendingPathComponent(sample.name)
                let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                    return url
                }
                self.client?.files.download(path: filePath, overwrite: true, destination: destination).response { response, error in
                    print(response)

                }
                _ = self.dataManager.saveAudio(sample.name)
            }
        }
    }

    private func loadAnimations() {
        let json = Data()
        guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: [])) as? [String: Any] else {
            return
        }
        for (_, jsonString) in dictionary {
            guard let animationJSON = jsonString as? String else {
                continue
            }
            _ = dataManager.saveAnimation(animationJSON)
        }

    }

    private func loadSessions() {
        let json = Data()
        guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: [])) as? [String: Any] else {
            return
        }
        for (name, object) in dictionary {
            guard let sessionName = name as? String,
                let sessionData = object as? Data else {
                    continue
            }
            guard let session = Session(json: sessionData) else {
                continue
            }
            _ = dataManager.saveSession(sessionName, session)
        }

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
        let animationTypes = dataManager.loadAllAnimationTypes().flatMap{AnimationType.getAnimationTypeFromJSON(fromJSON: $0) }
        var dictionary = [String: String]()
        for animation in animationTypes {
            guard let jsonString = animation.getJSONforAnimationType() else {
                continue
            }
            dictionary[animation.name] = jsonString
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return
        }

        let filePath = "/\(Config.AnimationFileName)/\(Config.AnimationExt))"
        client?.files.upload(path: filePath, input: jsonData)

    }

    private func saveSessions() {
        let sessions = dataManager.loadAllSessionNames().flatMap { dataManager.loadSession($0) }
        var dictionary = [String: Data]()
        for session in sessions {
            guard let name = session.getSessionName(),
                let json = session.toJSON() else {
                    continue
            }
            dictionary[name] = json
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return
        }
        let filePath = "/\(Config.SessionFileName)/\(Config.SessionExt))"
        client?.files.upload(path: filePath, input: jsonData)

    }

    private func fileExists(_ filePath: String) -> Bool {
        return false
    }

    private func isSoundFile(_ fileName: String) -> Bool {
        let soundExtensions = [".wav"]
        for suffix in soundExtensions {
            if fileName.hasSuffix(suffix) {
                return true
            }
        }
        return false
    }
}
