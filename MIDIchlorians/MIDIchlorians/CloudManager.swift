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

    private func postToNotificationCenter(_ key: String, _ result: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: key),
                                        object: self, userInfo: ["success": result])
    }

    //Loads items from Dropbox into App's Documents directory
    // Posts 3 notifications indicating success or failure, one each for sessions, animations and audios
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
        var samplesReceived = [String]()
        var numSamples = 0
        var notificationPosted = false

        func downloadCallback(_ result: (Files.FileMetadataSerializer.ValueType, URL),
                              _ sample: String) {
            samplesReceived.append(sample)
            guard samplesReceived.count == numSamples else {
                return
            }
            for sample in samplesReceived {
                //What if the saving fails?
                _ = dataManager.saveAudio(sample)
            }
            postToNotificationCenter(Config.audioNotificationKey, true)
        }

        func listFolderCallback(result: Files.ListFolderResultSerializer.ValueType) {
            numSamples = result.entries.count
            for sample in result.entries {
                guard self.isSoundFile(sample.name) else {
                    continue
                }
                let filePath = "/\(Config.AudioFolderName)/\(sample.name)"
                let url = docsURL.appendingPathComponent(sample.name)
                let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                    return url
                }
                self.client?.files.download(path: filePath,
                                            overwrite: true,
                                            destination: destination).response { response, error in
                    guard let result = response, error == nil else {
                        if !notificationPosted {
                            self.postToNotificationCenter(Config.audioNotificationKey, false)
                            notificationPosted = true
                        }
                        return
                    }
                    downloadCallback(result, sample.name)
                }

            }
        }

        client?.files.listFolder(path: "/\(Config.AudioFolderName)/").response { response, error in
            guard let result = response, error == nil else {
                self.postToNotificationCenter(Config.audioNotificationKey, false)
                return
            }
            listFolderCallback(result: result)
        }


    }

    private func loadAnimations() {
        let filePath = "/\(Config.AnimationFileName)/\(Config.AnimationExt)"

        func downloadCallBack(_ result: (Files.FileMetadataSerializer.ValueType, Data)) {
            let json = result.1
            guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: []))
                                         as? [String: Any] else {
                self.postToNotificationCenter(Config.animationNotificationKey, false)
                return
            }
            for (_, jsonString) in dictionary {
                guard let animationJSON = jsonString as? String else {
                    //Data not represented properly, How should we handle this?
                    continue
                }
                //What if saving fails
                _ = self.dataManager.saveAnimation(animationJSON)
            }
            self.postToNotificationCenter(Config.animationNotificationKey, true)
        }

        client?.files.download(path: filePath).response { response, error in
            guard let result = response, error == nil else {
                self.postToNotificationCenter(Config.animationNotificationKey, false)
                return
            }
            downloadCallBack(result)
        }
    }

    private func loadSessions() {
        let filePath = "/\(Config.SessionFileName)/\(Config.SessionExt)"

        func downloadCallBack(_ result: (Files.FileMetadataSerializer.ValueType, Data)) {
            let json = result.1
            guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: []))
                                         as? [String: Any] else {
                self.postToNotificationCenter(Config.sessionNotificationKey, false)
                return
            }
            for (sessionName, object) in dictionary {
                guard let sessionData = object as? Data else {
                    continue
                }
                guard let session = Session(json: sessionData) else {
                    continue
                }
                _ = self.dataManager.saveSession(sessionName, session)

            }
            self.postToNotificationCenter(Config.sessionNotificationKey, true)
        }

        client?.files.download(path: filePath).response { response, error in
            guard let result = response, error == nil else {
                self.postToNotificationCenter(Config.sessionNotificationKey, false)
                return
            }
            downloadCallBack(result)
        }

    }

    // Uploads items to Dropbox from App's Documents directory
    // Posts 3 notifications indicating success or failure, one each for sessions, animations and audios
    func saveToDropbox() {
        saveAudios()
        saveAnimations()
        saveSessions()
    }

    private func saveAudios() {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
            self.postToNotificationCenter(Config.audioNotificationKey, false)
            return
        }
        //Get a list of samples
        let samples = dataManager.loadAllAudioStrings()
        var notificationPosted = false
        var numSamplesUploaded = 0

        func uploadCallback(_ result: Files.FileMetadataSerializer.ValueType) {
            guard samples.count == numSamplesUploaded else {
                return
            }
            self.postToNotificationCenter(Config.audioNotificationKey, true)
        }

        func getMetaDataCallback(filePath: String, sample: String) {
            let url = docsURL.appendingPathComponent("\(sample).\(Config.SoundExt)")
            self.client?.files.upload(path: filePath, input: url).response { response, error in
                guard let result = response, error == nil else {
                    if !notificationPosted {
                        self.postToNotificationCenter(Config.audioNotificationKey, false)
                        notificationPosted = true
                    }
                    return
                }
                numSamplesUploaded += 1
                uploadCallback(result)
            }
        }

        //Upload each sample
        for sample in samples {
            let fileNameExtension = "\(sample).\(Config.SoundExt)"
            let filePath = "/\(Config.AudioFolderName)/\(fileNameExtension)"
            client?.files.getMetadata(path: filePath).response { response, error in
                guard response == nil, error != nil else {
                    //File already exists
                    return
                }
                getMetaDataCallback(filePath: filePath, sample: sample)
            }

        }
    }

    private func saveAnimations() {
        let animationTypes = dataManager.loadAllAnimationTypes().flatMap
            { AnimationType.getAnimationTypeFromJSON(fromJSON: $0) }
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

        let filePath = "/\(Config.AnimationFileName).\(Config.AnimationExt)"
        client?.files.upload(path: filePath, input: jsonData).response { response, error in
            guard response != nil, error == nil else {
                self.postToNotificationCenter(Config.animationNotificationKey, false)
                return
            }
            self.postToNotificationCenter(Config.animationNotificationKey, true)
        }

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
        let filePath = "/\(Config.SessionFileName).\(Config.SessionExt)"
        client?.files.upload(path: filePath, input: jsonData).response{ response, error in
            guard response != nil, error == nil else {
                self.postToNotificationCenter(Config.sessionNotificationKey, false)
                return
            }
            self.postToNotificationCenter(Config.sessionNotificationKey, true)
        }

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
