//
//  AppDelegate.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy private var preloadedSamples = Config.sound.joined()
    lazy private var preloadedAnimationTypes = Config.preloadedAnimationTypes

    // Copy samples from the bundle onto user's document directory.
    // A list of URLs of the copied samples.

    private func copyBundleSamples() {
        preloadedSamples.forEach { sample in
            copyToUserStorage(sample)
        }
    }

    // Helper to copy form src to destination
    private func copy(src: URL, dest: URL) {
        do {
            try FileManager.default.copyItem(at: src, to: dest)
        } catch {
            return
        }
    }

    private func copyToUserStorage(_ sampleName: String) {
        // store the samples in the document directory
        guard let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            // if we cannot store, that's fine, the user just won't have any samples loaded
            return
        }
        let sampleURL = Bundle.main.url(forResource: sampleName, withExtension: Config.SoundExt)
        guard let srcURL = sampleURL else {
            return
        }
        let destURL = docsURL.appendingPathComponent("\(sampleName).\(Config.SoundExt)")
        copy(src: srcURL, dest: destURL)
    }

    //Get all samples present in documents directory
    private func getAppSamples() -> [String] {
        guard let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return []
        }

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: docsURL, includingPropertiesForKeys: nil, options: [])
            let audioFiles = directoryContents.filter{ $0.pathExtension == Config.SoundExt }
                                              .map { $0.deletingPathExtension().lastPathComponent }
            return audioFiles

        } catch {
            return []
        }
    }
  
    private func copyBundleAnimationTypes() -> [String] {
        return preloadedAnimationTypes.flatMap { getStringFromFile(fileName: $0) }
    }

    private func getStringFromFile(fileName: String) -> String? {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "")
        guard let path = filePath else {
            return nil
        }
        let contents = try? String(contentsOfFile: path, encoding: .utf8)
        return contents
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Get app keys
        var keys: NSDictionary?

        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let applicationId = keys?["DropboxAppId"] as? String {
            //Initalise dropbox client
            DropboxClientsManager.setupWithAppKey(applicationId)
        } else {
            print("Cannot find dropbox key")
        }

        // Try to find a session that was last loaded
        // if not loaded should create an empty session

        // Copy all samples into user directory
        copyBundleSamples()

        //Get all samples in user directory
        let appSamples = getAppSamples()

        // Populate the samples in our database
        appSamples.forEach { sample in
            // if saving fails, what are we gonna do?
            let _ = DataManager.instance.saveAudio(sample)
        }

        // Do the same thing for animations as well
        let copiedPreloadedAnimations = copyBundleAnimationTypes()

        copiedPreloadedAnimations.forEach { preloadedAnimation in
            // if saving fails, what are we gonna do?
            _ = DataManager.instance.saveAnimation(preloadedAnimation)
        }
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

