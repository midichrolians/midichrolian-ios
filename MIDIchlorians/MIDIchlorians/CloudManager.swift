//
//  CloudManager.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 1/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import SwiftyDropbox
/**
 This class handles the operations for saving and loading data from cloud resources(in this case,
 Dropbox). Since the API requests are asynchronous, it posts notifications on completion to indicate
 success/failure.
 **/
class CloudManager {

    private let dataManager: DataManager
    private var client: DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }
    //The total number of results expected
    private let numResultsExpected: Int
    //Counts the number of requests for which results(success/failure) have been obtained
    private var resultsReceived: Int
    //Variable to indicate if the entire process was successful
    private var isSuccessful: Bool

    init() {
        dataManager = DataManager.instance
        numResultsExpected = Config.numberOfItemsToSync
        resultsReceived = 0
        isSuccessful = true
    }

    private func postToNotificationCenter(_ key: String, _ result: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: key),
                                        object: self, userInfo: ["success": result])
    }

    //Handles the result of a save/load operation. There are 3 in total, one each for animations,
    //audios, and sessions. On completion of all 3, a final notification is posted
    private func handleResult(_ key: String, _ result: Bool) {
        if !result {
            isSuccessful = false
        }
        resultsReceived += 1
        postToNotificationCenter(key, result)
        if resultsReceived  == numResultsExpected {
            postToNotificationCenter(Config.cloudNotificationKey, isSuccessful)
            resultsReceived = 0
            isSuccessful = true
        }
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
           self.handleResult(Config.audioNotificationKey, false)
           return
        }
        let samples = dataManager.loadAllAudioStrings()
        var sampleMap = Set<String>()
        samples.forEach({ sample in
            sampleMap.insert(sample)
        })
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
                _ = dataManager.addAudioToGroup(group: Config.defaultGroup, audio: sample)
            }
            self.handleResult(Config.audioNotificationKey, true)
        }

        func listFolderCallback(result: Files.ListFolderResultSerializer.ValueType) {
            numSamples = result.entries.count
            for sample in result.entries {
                guard self.isSoundFile(sample.name) else {
                    continue
                }

                if sampleMap.contains(sample.name) {
                    numSamples -= 1
                    if numSamples == 0 {
                        self.handleResult(Config.audioNotificationKey, true)
                        return
                    }
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
                            self.handleResult(Config.audioNotificationKey, false)
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
                self.handleResult(Config.audioNotificationKey, false)
                return
            }
            listFolderCallback(result: result)
        }
    }

    private func loadAnimations() {
        let filePath = "/\(Config.AnimationFileName).\(Config.AnimationExt)"

        func downloadCallBack(_ result: (Files.FileMetadataSerializer.ValueType, Data)) {
            let json = result.1
            guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: []))
                                         as? [String: Any] else {
                self.handleResult(Config.animationNotificationKey, false)
                return
            }
            for (_, jsonString) in dictionary {
                guard let animationJSON = jsonString as? String else {
                    //Data not represented properly, How should we handle this?
                    continue
                }
                //What if saving fails
                _ = dataManager.saveAnimation(animationJSON)
            }
            self.handleResult(Config.animationNotificationKey, true)
        }

        client?.files.download(path: filePath).response { response, error in
            guard let result = response, error == nil else {
                self.handleResult(Config.animationNotificationKey, false)
                return
            }
            downloadCallBack(result)
        }
    }

    private func loadSessions() {
        let filePath = "/\(Config.SessionFileName).\(Config.SessionExt)"

        func downloadCallBack(_ result: (Files.FileMetadataSerializer.ValueType, Data)) {
            let json = result.1
            guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: []))
                                         as? [String: Any] else {
                self.handleResult(Config.sessionNotificationKey, false)
                return
            }
            for (sessionName, object) in dictionary {
                guard let sessionData = object as? String else {
                    continue
                }
                guard let session = Session(json: sessionData) else {
                    continue
                }
                _ = self.dataManager.saveSession(sessionName, session)

            }
            self.handleResult(Config.sessionNotificationKey, true)
        }

        client?.files.download(path: filePath).response { response, error in
            guard let result = response, error == nil else {
                self.handleResult(Config.sessionNotificationKey, false)
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
            self.handleResult(Config.audioNotificationKey, false)
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
            self.handleResult(Config.audioNotificationKey, true)
        }

        func getMetaDataCallback(filePath: String, sample: String) {
            let url = docsURL.appendingPathComponent("\(sample)")
            self.client?.files.upload(path: filePath, input: url).response { response, error in
                guard let result = response, error == nil else {
                    if !notificationPosted {
                        self.handleResult(Config.audioNotificationKey, false)
                        notificationPosted = true
                    }
                    return
                }
                numSamplesUploaded += 1
                uploadCallback(result)
            }
        }
        var numExisting = 0
        //Upload each sample
        for sample in samples {
            let fileNameExtension = "\(sample)"
            let filePath = "/\(Config.AudioFolderName)/\(fileNameExtension)"
            client?.files.getMetadata(path: filePath).response { response, error in
                guard response == nil, error != nil else {
                    //File already exists
                    numExisting += 1
                    if numExisting == samples.count {
                        self.handleResult(Config.audioNotificationKey, true)
                    }
                    return
                }
                getMetaDataCallback(filePath: filePath, sample: sample)
            }

        }
    }

    private func saveAnimations() {
        let animationTypes = dataManager.loadAllAnimationTypes().flatMap {
            AnimationType(fromJSON: $0) }
        var dictionary = [String: String]()
        for animation in animationTypes {
            guard let jsonString = animation.getJSON() else {
                continue
            }
            dictionary[animation.name] = jsonString
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return
        }

        let filePath = "/\(Config.AnimationFileName).\(Config.AnimationExt)"
        client?.files.upload(path: filePath, mode: Files.WriteMode.overwrite, autorename: false, mute: false,
                             input: jsonData).response { response, error in
            guard response != nil, error == nil else {
                self.handleResult(Config.animationNotificationKey, false)
                return
            }
            self.handleResult(Config.animationNotificationKey, true)
        }

    }

    private func saveSessions() {
        let sessions = dataManager.loadAllSessionNames().flatMap { dataManager.loadSession($0) }
        var dictionary = [String: String]()
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
        client?.files.upload(path: filePath, mode: Files.WriteMode.overwrite, autorename: false, mute: false,
                             input: jsonData).response { response, error in
            guard response != nil, error == nil else {
                self.handleResult(Config.sessionNotificationKey, false)
                return
            }
            self.handleResult(Config.sessionNotificationKey, true)
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
