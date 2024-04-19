//
//  NowPlayingMonitor.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI
import DynamicNotchKit
import PrivateMediaRemote

class NowPlayingMonitor: MonitorProtocol {
    private var nowPlayingItem: NowPlayingItem?

    func addObservers() {
        // Initialize nowPla
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            if let information = information {
                self.nowPlayingItem = self.getNowPlayingItem(from: information)
            }
        }

        // Set up the observer
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.mrMediaRemoteNowPlayingInfoDidChange,
            object: nil,
            queue: nil
        ) { _ in
            self.updateData()
        }

        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main)
    }
    
    func updateData() {
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            if let information = information {
                let newItem = self.getNowPlayingItem(from: information)

                if let newItem = newItem,
                   newItem.isDifferentState(from: self.nowPlayingItem) {

                    // MARK: EXPERIMENTAL
                    guard newItem.artwork != nil else { return }

                    self.nowPlayingItem = newItem
                    self.show()
                }

                // If the now playing view is open, this notification will update it.
                NotificationCenter.default.post(name: .nowPlayingChanged, object: newItem)
            }
        }
    }
    
    func show() {
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            if let information = information {
                guard let item = self.getNowPlayingItem(from: information) else { return }

                if let appDelegate = AppDelegate.shared {
                    guard !(appDelegate.dynamicNotch?.isVisible ?? false) else {
                        return
                    }

                    appDelegate.dynamicNotch = DynamicNotch(content: NowPlayingView(item))
                    appDelegate.lastShownMonitor = self
                    appDelegate.dynamicNotch?.show(for: 3)
                }
            }
        }
    }

    func getNowPlayingItem(from information: [AnyHashable: Any]) -> NowPlayingMonitor.NowPlayingItem? {
        guard
            let playbackRate = information[kMRMediaRemoteNowPlayingInfoPlaybackRate] as? Double,
            let artist = information[kMRMediaRemoteNowPlayingInfoArtist] as? String,
            let title = information[kMRMediaRemoteNowPlayingInfoTitle] as? String,
            let album = information[kMRMediaRemoteNowPlayingInfoAlbum] as? String
        else {
            return nil
        }

        // Image is optional
        var image: NSImage?
        if let data = information["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
            image = NSImage(data: data)
        }

        let nowPlayingItem = NowPlayingMonitor.NowPlayingItem(
            artist: artist,
            title: title,
            album: album,
            artwork: image,
            isPlaying: playbackRate != .zero
        )

        return nowPlayingItem
    }
}
