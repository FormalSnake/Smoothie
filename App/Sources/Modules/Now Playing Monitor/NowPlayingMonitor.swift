//
//  NowPlayingMonitor.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI
import DynamicNotchKit

// https://github.com/JohnCoates/Aerial/blob/6b0f608c84511f86efec0de85aced2ba060bc41c/Aerial/Source/Models/Music/Music.swift#L36
class NowPlayingMonitor: MonitorProtocol {
    private var nowPlayingItem: NowPlayingItem?

    func addObservers() {
        // Initialize nowPla
        let MRMediaRemoteGetNowPlayingInfo = getMRMediaRemoteGetNowPlayingInfoFunction()
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            self.nowPlayingItem = self.getNowPlayingItem(from: information)
        }

        // Set up the observer
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "kMRMediaRemoteNowPlayingInfoDidChangeNotification"),
            object: nil,
            queue: nil
        ) { _ in
            self.updateData()
        }

        let MRMediaRemoteRegisterForNowPlayingNotifications = getMRMediaRemoteRegisterForNowPlayingNotificationsFunction()
        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main)
    }
    
    func updateData() {
        let MRMediaRemoteGetNowPlayingInfo = getMRMediaRemoteGetNowPlayingInfoFunction()
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            let newItem = self.getNowPlayingItem(from: information)

            if let newItem = newItem,
               newItem.isDifferentSong(from: self.nowPlayingItem) {

                self.nowPlayingItem = newItem
                self.show()
            }

            // If the now playing view is open, this notification will update it.
            NotificationCenter.default.post(name: .nowPlayingChanged, object: newItem)
        }
    }
    
    func show() {
        let MRMediaRemoteGetNowPlayingInfo = getMRMediaRemoteGetNowPlayingInfoFunction()
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            guard let item = self.getNowPlayingItem(from: information) else { return }
            
            if let appDelegate = AppDelegate.shared {
                if let dynamicNotch = appDelegate.dynamicNotch,
                   dynamicNotch.isVisible {
                    return
                }
                appDelegate.dynamicNotch = DynamicNotch(content: NowPlayingView(item))
                appDelegate.dynamicNotch?.show(for: 2)
            }
        }
    }
}
