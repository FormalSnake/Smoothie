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
    private var lastShownTime: Date?
    private let showInterval: TimeInterval = 10.0 // 10 seconds
    
    func addObservers() {
        // Initialize nowPlayingItem
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
                
                if let newItem = newItem {
                    let hasChanged = self.nowPlayingItem?.title != newItem.title || self.nowPlayingItem?.artist != newItem.artist
                    let playbackStateChanged = newItem.isPlaying != self.nowPlayingItem?.isPlaying
                    let shouldShow = hasChanged || playbackStateChanged
                    
                    if shouldShow {
                        let now = Date()
                        if hasChanged || (playbackStateChanged && (self.lastShownTime == nil || now.timeIntervalSince(self.lastShownTime!) >= self.showInterval)) {
                            self.nowPlayingItem = newItem
                            self.lastShownTime = now
                            self.show()
                        }
                    }
                }
                
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
