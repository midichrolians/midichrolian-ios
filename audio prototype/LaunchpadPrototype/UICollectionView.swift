//
//  UICollectionView.swift
//  LaunchpadPrototype
//
//  Created by Ten Zhi yang on 3/3/17.
//  Copyright © 2017 Ten Zhi yang. All rights reserved.
//

import UIKit

class UICollectionViewExtension: UICollectionView {
    let audioManager = AudioManager()

    func startListenAudio() {
        let ncdefault = NotificationCenter.default
        ncdefault.addObserver(forName: Notification.Name(rawValue:"Sound"), object: nil, queue: nil) {
            notification in
            //handle notification
            guard let completedID = notification.userInfo?["completed"] as? UInt32 else {
                return
            }
            let cellPath = self.audioManager.getIndexPath(of: completedID)
            guard let cell = self.cellForItem(at: cellPath) else {
                return
            }
            cell.backgroundColor = UIColor.gray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLoc = touch.location(in: self)
            handleTapCell(at: touchLoc)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func handleTapCell(at location: CGPoint) {
        guard let touchIndex = indexPathForItem(at: location) else {
            return
        }
        
        handleAudio(buttonIndex: touchIndex)
    }
    
    func handleAudio(buttonIndex: IndexPath) {
        guard let cell = cellForItem(at: buttonIndex) else {
            return
        }
        
        if audioManager.play(indexPath: buttonIndex) {
            cell.backgroundColor = UIColor.green
        }
    }
    
}
