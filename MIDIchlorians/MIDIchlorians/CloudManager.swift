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
                let fileNameExtension = "\(sample.name).\(Config.SoundExt)"
                let filePath = "/\(Config.AudioFolderName)/\(fileNameExtension)"
                let url = docsURL.appendingPathComponent("\(sample.name).\(Config.SoundExt)")
                let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                    return url
                }
                self.client?.files.download(path: filePath, overwrite: true, destination: destination)
                _ = self.dataManager.saveAudio(sample.name)
            }
        }
    }


    private func loadAnimations() {
        //Download to data object
    }

    private func loadSessions() {
        //Download to data object
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
        //TODO: COnvert array of strings to Data object
        let animationJSONs = dataManager.loadAllAnimationTypes()
        let data = Data()
        let filePath = "/\(Config.AnimationFileName)/\(Config.AnimationExt))"
        client?.files.upload(path: filePath, input: data)

    }

    private func saveSessions() {
        let sessions = dataManager.loadAllSessionNames().flatMap { dataManager.loadSession($0) }
            .map {($0, $0.serialise())}
        let data = Data()
        let filePath = "/\(Config.SessionFileName)/\(Config.SessionExt))"
        client?.files.upload(path: filePath, input: data)

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
