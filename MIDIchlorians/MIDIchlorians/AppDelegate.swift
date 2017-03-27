//
//  AppDelegate.swift
//  MIDIchlorians
//
//  Created by anands on 8/3/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy private var preloadedSamples = Config.sound.joined()

    func copyBundleSamples() {
        // store the samples in the document directory
        guard let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            // if we cannot store, that's fine, the user just won't have any samples loaded
            return
        }

        // for each of the song we have bundled, copy them into the directory
        preloadedSamples.forEach { sampleName in
            if let sampleInBundle = Bundle.main.url(forResource: sampleName, withExtension: Config.SoundExt) {
                let dest = docsURL.appendingPathComponent("\(sampleName).\(Config.SoundExt)")
                if !FileManager.default.fileExists(atPath: dest.path) {
                    try? FileManager.default.copyItem(at: sampleInBundle, to: dest)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Try to find a session that was last loaded
        // if not loaded should create an empty session

        // Copy all samples into user directory
        copyBundleSamples()

        // Populate the samples in our database
        preloadedSamples.forEach { sample in
            // if saving fails, what are we gonna do?
            let _ = DataManager.instance.saveAudio(sample)
        }

        // Do the same thing for animations as well

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

