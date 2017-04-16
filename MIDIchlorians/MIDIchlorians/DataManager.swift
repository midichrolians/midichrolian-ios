//
//  SessionSaver.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 18/03/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import RealmSwift
/**
 This class is responsible for all persistence and storage related functions, such as saving/loading
 /deleting objects, etc.
 
 The singleton pattern is used here, as we want only one instance of the class to be created in the 
 entire app. One of the reasons for doing this is that this is the only class that deals with Realm,
 and so if we want to migrate away from realm in the future, none of the APIs of this
 class will have to change, since the Realm object is not exposed.
 
 When the lone instance is created, we load the list of all session names, audios, audio groups,
 and animations, and store create Sets for each of them. This is analogous to a form of caching,
 as it enables efficient checking for duplicates while adding and deleting objects, rather than
 querying the database to do so.
 **/
class DataManager {

    private let realm: Realm?
    static let instance = DataManager()
    private var sessionNames: Set<String>
    private var animationStrings: Set<String>
    private var audioStrings: Set<String>
    private var audioGroups: Set<String>
    //Stores the name of the last session accessed by the user
    private var lastSessionName: String?

    init() {
        //Not sure if this line should always be there
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        //Syntax for getting realm instance
        realm = try? Realm()
        lastSessionName = nil
        //Create the sets for efficient lookup and initialise them
        sessionNames = Set<String>()
        animationStrings = Set<String>()
        audioStrings = Set<String>()
        audioGroups = Set<String>()
        initialiseSessionNames()
        initialiseAnimations()
        initialiseAudios()
        initialiseAudioGroups()
    }

    private func initialiseSessionNames() {
        guard let sessionNames = realm?.objects(SessionName.self) else {
            return
        }
        for sessionName in sessionNames {
            if let sessionNameString = sessionName.getSessionName() {
                self.sessionNames.insert(sessionNameString)
                lastSessionName = sessionNameString
            }
        }
    }

    private func initialiseAnimations() {
        guard let animations = realm?.objects(Animation.self) else {
            return
        }
        for animation in animations {
            if let animationString = animation.getAnimationType() {
                animationStrings.insert(animationString)
            }
        }
    }

    private func initialiseAudios() {
        guard let audios = realm?.objects(Audio.self) else {
            return
        }
        for audio in audios {
            if let audioString = audio.getAudioFile() {
                audioStrings.insert(audioString)
            }
        }
    }

    private func initialiseAudioGroups() {
        guard let groups = realm?.objects(AudioGroup.self) else {
            return
        }
        for group in groups {
            if let groupName = group.getGroupName() {
                audioGroups.insert(groupName)
            }
        }
    }

    /**
     Saves a session in the database, assigning it's name to the value 'sessionName'
     Once a session is persisted, it needs to be wrapped within a realm.write to update. Because
     of this, a copy of the session is returned, so that the session can be updated via the usual
     functions in the model, rather than having to go through DataManager. Due to this, one only
     has to call DataManager once all changes to the model are made, to save the object. This
     provides for more efficient operations, as we don't have to update the database for every
     update, instead doing so only when we save.
     
     The value returned is an optional, where nil indicates that the saving failed.
     
     In case the session already has a name assigned to it, the name is overrwriten with the value
     provided.
    **/
    func saveSession(_ sessionName: String, _ session: Session) -> Session? {
        var sessionToBeSaved = session
        if session.getSessionName() != nil {
            //Create copy, as we cannot change the primary key(session name) of an object
            //Due to this, if an older version of this session had a different name, that does not
            //get overwritten
            sessionToBeSaved = Session(session: session)
        }
        //Prepares the session object for saving. This assigns the session to the name provided
        //while calling the function
        sessionToBeSaved.prepareForSave(sessionName: sessionName)

        do {
            //Create session name if it is doe not already exist
            if !sessionNames.contains(sessionName) {
                try realm?.write { realm?.add(SessionName(sessionName)) }
            }
            try realm?.write { realm?.add(sessionToBeSaved, update: true) }
        } catch {
            return nil
        }

        //Insert session name if it does not already exist
        if !sessionNames.contains(sessionName) {
            sessionNames.insert(sessionName)
        }

        lastSessionName = sessionName
        // Returns copy
        return Session(session: session)
    }

    // Function to change the name of a session. Returns boolean indicating success/failure
    func editSessionName(oldSessionName: String, newSessionName: String) -> Bool {
        guard sessionNames.contains(oldSessionName) else {
            return false
        }

        guard let session = loadSession(oldSessionName) else {
            return false
        }

        guard removeSession(oldSessionName) else {
            return false
        }

        return saveSession(newSessionName, session) != nil
    }

    //Deletes a session with the given name. Does nothing if none exists
    func removeSession(_ sessionName: String) -> Bool {
        guard sessionNames.contains(sessionName) else {
            return true
        }

        do {
            guard let session = loadExactSession(sessionName) else {
                //Indicate failure if error occurred
                return false
            }
            //Delete session name from Database
            if let sessionNameObject = realm?.object(ofType: SessionName.self,
                                                     forPrimaryKey: sessionName) {
                try realm?.write { realm?.delete(sessionNameObject) }
            }
            //Delete session from Database
            try realm?.write {
                for pad in session.getPadList() {
                    realm?.delete(pad)
                }
                realm?.delete(session)
            }
        } catch {
            //Indicate failure if error occurred
            return false
        }
        //Remove session name from cached set
        sessionNames.remove(sessionName)

        return true
    }

    // Function for internal use. Returns the session specified by a given session name.
    // Unlike load session, this function returns the same session object, rather than a copy
    private func loadExactSession(_ sessionName: String) -> Session? {
        guard sessionNames.contains(sessionName) else {
            return nil
        }
        //Load session from database
        guard let session = realm?.object(ofType: Session.self, forPrimaryKey: sessionName) else {
                //Indicate failure if error occurred
                return nil
        }
        session.prepareForUse()
        return session
    }

    //Loads a session with the given name. Returns nil if none exists, or if error occurs
    //Returns a copy so that caller can modify the session object
    func loadSession(_ sessionName: String) -> Session? {
        guard sessionNames.contains(sessionName) else {
            return nil
        }
        //Load session from database
        guard let session = realm?.object(ofType: Session.self, forPrimaryKey: sessionName) else {
                //Indicate failure if error occurred
                return nil
        }
        session.prepareForUse()
        let copiedSession = Session(session: session)
        return copiedSession
    }

    func loadAllSessionNames() -> [String] {
        return Array(sessionNames)
    }

    //Saves an animation object with the given animation type(represented as a json string).
    //Returns a boolean to indicate success or failure. Does nothing if it already exists
    func saveAnimation(_ animationString: String) -> Bool {
        if animationStrings.contains(animationString) {
            return true
        }

        do {
            try realm?.write { realm?.add(Animation(animationString)) }
        } catch {
            return false
        }

        if !animationStrings.contains(animationString) {
            animationStrings.insert(animationString)
        }

        return true
    }

    //Removes an animation type with the given json. Does nothing if the animation does not exist
    func removeAnimation(_ animationString: String) -> Bool {

        guard animationStrings.contains(animationString) else {
            return true
        }

        do {
            guard let animationObject = realm?.object(ofType: Animation.self,
                                                      forPrimaryKey: animationString) else {

                return false
            }
            try realm?.write { realm?.delete(animationObject) }
        } catch {
            return false
        }

        animationStrings.remove(animationString)

        return true

    }

    func loadAllAnimationTypes() -> [String] {
        return Array(animationStrings)
    }

    //Saves an audio object with the given name(audioFile). Returns a boolean
    //to indicate success or failure. Does nothing if it already exists
    func saveAudio(_ audioFile: String) -> Bool {
        if audioStrings.contains(audioFile) {
            return true
        }

        do {
            try realm?.write { realm?.add(Audio(audioFile)) }
        } catch {
            return false
        }

        if !audioStrings.contains(audioFile) {
            audioStrings.insert(audioFile)
        }
        return true
    }

    //Removes the audio object with the given name(audioFile). Does nothing if none exists
    func removeAudio(_ audioFile: String) -> Bool {
        guard audioStrings.contains(audioFile) else {
            return true
        }

        do {
            guard let audioObject = realm?.object(ofType: Audio.self,
                                                  forPrimaryKey: audioFile) else {

                return false
            }
            try realm?.write { realm?.delete(audioObject) }
        } catch {
            return false
        }

        audioStrings.remove(audioFile)

        return true

    }

    func loadAllAudioStrings() -> [String] {
        return Array(audioStrings)
    }

    //Returns last session used by the user. Returns nil if none exists
    func loadLastSession() -> Session? {
        if let lastSessionName = self.lastSessionName {
            return loadSession(lastSessionName)
        } else {
            return nil
        }
    }

    //Returns a list all audio files with a given audio group
    func getAudiosForGroup(group: String) -> [String] {
        guard let audiosResultObject = realm?.objects(Audio.self).filter("audioGroup = %@", group) else {
            return []
        }
        var audios = [String]()
        for audio in audiosResultObject {
            if let audioFile = audio.getAudioFile() {
                audios.append(audioFile)
            }
        }
        return audios
    }

    //Adds an audio file to a particular audio group
    //Returns false if the audio does not exist in the database
    func addAudioToGroup(group: String, audio: String) -> Bool {
        guard audioStrings.contains(audio) else {
            return false
        }
        guard let audio = realm?.object(ofType: Audio.self, forPrimaryKey: audio) else {
            return false
        }
        do {
            try realm?.write {
                audio.setAudioGroup(group: group)
                //Create group
                if !audioGroups.contains(group) {
                    realm?.add(AudioGroup(group))
                    audioGroups.insert(group)
                }
            }
        } catch {
            return false
        }
        return true

    }

    //Creates a new audio group in the database. Does nothing if a group already exists
    func createAudioGroup(group: String) -> Bool {
        if audioGroups.contains(group) {
            return true
        }

        do {
            try realm?.write { realm?.add(AudioGroup(group)) }
        } catch {
            return false
        }

        audioGroups.insert(group)
        return true
    }

    func getAllAudioGroups() -> [String] {
        return Array(audioGroups)
    }

    //Returns group associated with a pad
    func getAudioGroup(pad: Pad) -> String? {
        guard let audioString = pad.getAudioFile() else {
            return nil
        }
        guard let audioObject = realm?.object(ofType: Audio.self, forPrimaryKey: audioString) else {
            return nil
        }

        return audioObject.getAudioGroup()

    }
}
