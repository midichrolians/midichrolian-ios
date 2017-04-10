//
//  SyncDelegate.swift
//  MIDIchlorians
//
//  Created by Advay Pal on 10/04/17.
//  Copyright © 2017 nus.cs3217.a0118897. All rights reserved.
//

// Adopt this protocol to react when dropbox web view needs to be loaded
protocol SyncDelegate: class {
    func loadDropboxWebView()
}
