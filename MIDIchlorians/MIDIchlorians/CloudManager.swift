//
//  CloudManager.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 1/4/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import SwiftyDropbox
/**
 This class handles the saving and loading of data from cloud services(Dropbox). Animations and
 Sessions are serialised to JSONs and saved, while Audio files are saved from the Documents
 Directory. The Singleton pattern is used here to prevent multiple instances from accessing the folder
 at the same time.
 
 Since the API requests are asynchronous, the notification center is used to indicate when a given
 request has received a result. One notification each is posted on obtaining results for animations,
 sessions and all audio files. Once all 3 have been received another notification is posted to indicate
 the overall completion of the sync.
 **/
class CloudManager {

    static let instance = CloudManager()
    private let dataManager = DataManager.instance
    private var client: DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }
    //Number of results required to indicate completion
    private let numResultsExpected = Config.numberOfItemsToSync
    //Number of results recived
    private var resultsReceived = 0
    //Variable to indicate whether the overall process has been successful
    private var isSuccessful = true

    private init() {
        //Just to ensure initialiser is private
    }

    private func postToNotificationCenter(_ key: String, _ result: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: key),
                                        object: self, userInfo: ["success": result])
    }

    private func handleResult(_ key: String, _ result: Bool) {
        //Set isSuccessful to false if the request failed
        if !result {
            isSuccessful = false
        }
        resultsReceived += 1
        //post notification
        postToNotificationCenter(key, result)
        // Indicates when all requests are complete
        if resultsReceived  == numResultsExpected {
            postToNotificationCenter(Config.cloudNotificationKey, isSuccessful)
            resultsReceived = 0
            isSuccessful = true
        }
    }

    // Loads items from Dropbox into App's Documents directory
    // Posts 3 notifications indicating success or failure, one each for sessions, animations and audios
    func loadFromDropbox() {
        loadAudios()
        loadAnimations()
        loadSessions()
    }

    // Downloads all audio files in the app folder in dropbox
    // Posts a notification on completion with result = true if all files have been downloaded
    // First makes an API request to get the names of all the files in the 'samples' folder
    // Then, downloads each file that is a valid sound file and does not already exist
    private func loadAudios() {
        //Get docs URL
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
           self.handleResult(Config.audioNotificationKey, false)
           return
        }

        let audios = dataManager.loadAllAudioStrings()
        //Create Set of all audios for quick lookup
        var audioMap = Set<String>()
        audios.forEach({ audio in
            audioMap.insert(audio)
        })
        //Array to keep track of audios received
        var numAudiosReceived = 0
        // Default value(is initalised again inside listFolderCallback)
        var numAudiosToDownload = 0
        var notificationPosted = false

        //Internal function that is called each time when an audio file has been downloaded
        func downloadCallback(_ result: (Files.FileMetadataSerializer.ValueType, URL),
                              _ audioFile: String) {

            numAudiosReceived += 1
            _ = dataManager.saveAudio(audioFile)
            _ = dataManager.addAudioToGroup(group: Config.defaultGroup, audio: audioFile)

            //Post notification only if all have been downloaded
            if numAudiosReceived == numAudiosToDownload {
                self.handleResult(Config.audioNotificationKey, true)
            }
        }

        //Internal function that is called after first API request, to get list of file names
        func listFolderCallback(result: Files.ListFolderResultSerializer.ValueType) {
            // We do not download if it already exists, or if it is not a sound file
            let filesToDownload = result.entries.filter({
                return self.isSoundFile($0.name) && !audioMap.contains($0.name)
            })

            numAudiosToDownload = filesToDownload.count

            // Return if there are no valid files to download
            if numAudiosToDownload == 0 {
                self.handleResult(Config.audioNotificationKey, true)
                return
            }

            for audio in filesToDownload {
                let filePath = "/\(Config.audioFolderName)/\(audio.name)"
                let url = docsURL.appendingPathComponent(audio.name)
                let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                    return url
                }
                //API request to download the file
                self.client?.files.download(path: filePath,
                                            overwrite: true,
                                            destination: destination).response { response, error in
                    //In case there was an error
                    guard let result = response, error == nil else {
                        if !notificationPosted {
                            self.handleResult(Config.audioNotificationKey, false)
                            notificationPosted = true
                        }
                        return
                    }
                    // Call downloadCallback only if there was no error on downloading
                    downloadCallback(result, audio.name)
                }

            }
        }

        client?.files.listFolder(path: "/\(Config.audioFolderName)/").response { response, error in
            //If error occurred
            guard let result = response, error == nil else {
                self.handleResult(Config.audioNotificationKey, false)
                return
            }
            listFolderCallback(result: result)
        }
    }

    // Downloads the animations.json file in the App's dropbox folder and saves the animations in the
    // local database The animations.json file is a json string comprising of many json strings,
    // one for each animation type
    private func loadAnimations() {
        let filePath = "/\(Config.animationFileName).\(Config.animationExt)"

        //Internal function called after file has been downloaded
        func downloadCallBack(_ result: (Files.FileMetadataSerializer.ValueType, Data)) {
            let json = result.1
            guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: []))
                                         as? [String: Any] else {
                self.handleResult(Config.animationNotificationKey, false)
                return
            }
            for (_, jsonString) in dictionary {
                guard let animationJSON = jsonString as? String else {
                    //Data in JSON not represented properly. We simply ignore that particular json
                    continue
                }
                _ = dataManager.saveAnimation(animationJSON)
            }
            self.handleResult(Config.animationNotificationKey, true)
        }

        client?.files.download(path: filePath).response { response, error in
            //In case an error occurred
            guard let result = response, error == nil else {
                self.handleResult(Config.animationNotificationKey, false)
                return
            }
            downloadCallBack(result)
        }
    }
    // Downloads the sessions.json file in the App's dropbox folder and saves the session in the
    // local database. The sessions.json file is a json string comprising of many json strings,
    // one for each session
    private func loadSessions() {
        let filePath = "/\(Config.sessionFileName).\(Config.sessionExt)"
        //Internal function called after file has been downloaded
        func downloadCallBack(_ result: (Files.FileMetadataSerializer.ValueType, Data)) {
            let json = result.1
            guard let dictionary = (try? JSONSerialization.jsonObject(with: json, options: []))
                                         as? [String: Any] else {
                self.handleResult(Config.sessionNotificationKey, false)
                return
            }
            for (sessionName, object) in dictionary {
                //Ignore particular session in case session data is not properly represented
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

    // Uploads items to Dropbox from App's Documents directory. Posts 3 notifications indicating 
    // success or failure, one each for sessions, animations and audios
    func saveToDropbox() {
        saveAudios()
        saveAnimations()
        saveSessions()
    }

    //Uploads the audio files in the app's documents directory and saves them on dropbox
    private func saveAudios() {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).last else {
            self.handleResult(Config.audioNotificationKey, false)
            return
        }
        //Get a list of audios, and put them in a set for efficient removal
        var audioMap = Set<String>()
        var numAudiosUploaded = 0
        //Reinitalised inside listFolderCallback
        var numAudiosToUpload = 0
        dataManager.loadAllAudioStrings().forEach({ audio in
            audioMap.insert(audio)
        })
        var notificationPosted = false

        //Internal function that is called each time after one file has been uploaded
        func uploadCallback(_ result: Files.FileMetadataSerializer.ValueType) {
            numAudiosUploaded += 1
            guard numAudiosUploaded == numAudiosToUpload else {
                return
            }
            self.handleResult(Config.audioNotificationKey, true)
        }

        //Internal function that is called after first API request, to get list of file names
        func listFolderCallback(response: Files.ListFolderResultSerializer.ValueType?) {

            //Construct list of files to upload
            if let result = response {
                result.entries.forEach({ audio in
                    if audioMap.contains(audio.name) {
                        audioMap.remove(audio.name)
                    }
                })
            }
            let filesToUpload = Array(audioMap)
            numAudiosToUpload = filesToUpload.count

            // Return if there are no valid files to upload
            if numAudiosToUpload == 0 {
                self.handleResult(Config.audioNotificationKey, true)
                return
            }

            for audio in filesToUpload {
                let fileNameExtension = "\(audio)"
                let filePath = "/\(Config.audioFolderName)/\(fileNameExtension)"
                let url = docsURL.appendingPathComponent("\(audio)")
                self.client?.files.upload(path: filePath, input: url).response { response, error in
                    guard let result = response, error == nil else {
                        if !notificationPosted {
                            self.handleResult(Config.audioNotificationKey, false)
                            notificationPosted = true
                        }
                        return
                    }
                    uploadCallback(result)
                }
            }
        }

        client?.files.listFolder(path: "/\(Config.audioFolderName)/").response { response, _ in
            listFolderCallback(response: response)
        }
    }
    //Saves the animations in the database onto dropbox. Constructs a single json comprising all
    //animations
    private func saveAnimations() {
        let animationTypes = dataManager.loadAllAnimationTypes().flatMap { AnimationType(fromJSON: $0) }
        var dictionary = [String: String]()
        //Serialise every animation into json and add to dictionary
        for animation in animationTypes {
            guard let jsonString = animation.getJSON() else {
                continue
            }
            dictionary[animation.name] = jsonString
        }
        //Serialise dictionary to json
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            self.handleResult(Config.animationNotificationKey, false)
            return
        }
        //Upload the file
        let filePath = "/\(Config.animationFileName).\(Config.animationExt)"
        client?.files.upload(path: filePath, mode: Files.WriteMode.overwrite, autorename: false,
                             mute: false, input: jsonData).response { response, error in
            //In case error occurred while uploading
            guard response != nil, error == nil else {
                self.handleResult(Config.animationNotificationKey, false)
                return
            }
            self.handleResult(Config.animationNotificationKey, true)
        }

    }

    //Serialises the sessions in the database, and constructs a single json comprising all sessions.
    //It then saves the json on dropbox
    private func saveSessions() {
        //Load all sessions
        let sessions = dataManager.loadAllSessionNames().flatMap { dataManager.loadSession($0) }
        var dictionary = [String: String]()
        //Serialise each session and add to dictionary
        for session in sessions {
            guard let name = session.getSessionName(),
                let json = session.toJSON() else {
                    continue
            }
            dictionary[name] = json
        }
        //Serialise dictionary
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            self.handleResult(Config.sessionNotificationKey, false)
            return
        }
        //Upload json
        let filePath = "/\(Config.sessionFileName).\(Config.sessionExt)"
        client?.files.upload(path: filePath, mode: Files.WriteMode.overwrite, autorename: false,
                             mute: false, input: jsonData).response { response, error in
            //Error occurred
            guard response != nil, error == nil else {
                self.handleResult(Config.sessionNotificationKey, false)
                return
            }
            self.handleResult(Config.sessionNotificationKey, true)
        }

    }

    //Checks if a given file is a sound file. Can easily be extended if we want to support more files
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
