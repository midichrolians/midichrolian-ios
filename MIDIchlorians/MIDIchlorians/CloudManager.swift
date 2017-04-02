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
    let dataManager = DataManager.instance
    private init() {
        //Just to ensure initialiser is private
    }

    func loadFromDropbox(client: DropboxClient) {
        loadAudios(client)
        loadAnimations(client)
        loadSessions(client)
    }

    private func loadAudios(_ client: DropboxClient) {
        
    }

    private func loadAnimations(_ client: DropboxClient) {
    }

    private func loadSessions(_ client: DropboxClient) {
    }

    func saveToDropbox(client: DropboxClient) {
        saveAudios(client)
        saveAnimations(client)
        saveSessions(client)
    }

    private func saveAudios(_ client: DropboxClient) {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }
        //Get a list of samples
        let samples = dataManager.loadAllAudioStrings()
        //Upload each sample
        for sample in samples {
            let url = docsURL.appendingPathComponent("\(sample).\(Config.SoundExt)")
            client.files.upload(path: "/\(Config.AudioFolderName)/\(sample).\(Config.SoundExt)", input: url)
        }
    }

    private func saveAnimations(_ client: DropboxClient) {

    }

    private func saveSessions(_ client: DropboxClient) {

    }
}
