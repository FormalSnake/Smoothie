//
//  NowPlayingMonitor.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI
import DynamicNotchKit

class NowPlayingMonitor: MonitorProtocol {
    private var lastPlayedItem: NowPlayingItem?

    var mediaRemoteBundle: CFBundle {
        CFBundleCreate(
          kCFAllocatorDefault,
          NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework")
        )
    }

    func addObservers() {
        let bundle = mediaRemoteBundle

        // MARK: Get a function pointer for MRMediaRemoteRegisterForNowPlayingNotifications
        let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(
            bundle,
            "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString
        )
        typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
        let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(
            MRMediaRemoteRegisterForNowPlayingNotificationsPointer,
            to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self
        )

        // Add notification for when song changes!
        NotificationCenter.default.addObserver(
                    forName: NSNotification.Name(rawValue: "kMRMediaRemoteNowPlayingInfoDidChangeNotification"),
                    object: nil,
                    queue: nil
        ) { _ in
            self.updateData()
        }

        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main)
    }
    
    func updateData() {
        let bundle = mediaRemoteBundle

        // MARK: Get a function pointer for MRMediaRemoteGetNowPlayingInfo
        guard let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString) else {
            return
        }

        typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void

        let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(
            MRMediaRemoteGetNowPlayingInfoPointer,
            to: MRMediaRemoteGetNowPlayingInfoFunction.self
        )

        // MARK: Register notification observer
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in

            let nowPlayingItem = self.processNowPlayingInfo(information)

            if nowPlayingItem != self.lastPlayedItem {
                self.lastPlayedItem = nowPlayingItem
                self.show()
            }

        }
    }
    
    func show() {
        guard let lastPlayedItem = self.lastPlayedItem else {
            return
        }

        if let appDelegate = AppDelegate.shared {

        if let dynamicNotch = appDelegate.dynamicNotch,
            dynamicNotch.isVisible {
            return
        }
            appDelegate.dynamicNotch = DynamicNotch(content: NowPlayingView(lastPlayedItem))
            appDelegate.dynamicNotch?.show(for: 2)
        }
    }

    private func processNowPlayingInfo(_ information: [String: Any]) -> NowPlayingItem {
        let artist = information["kMRMediaRemoteNowPlayingInfoArtist"] as? String
        let title = information["kMRMediaRemoteNowPlayingInfoTitle"] as? String
        let album = information["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
        var artwork: NSImage? = nil

        if let artworkData = information["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
            artwork = NSImage(data: artworkData)
        }

        NotificationCenter.default.post(name: .nowPlayingChanged, object: nil, userInfo: [
            "kMRMediaRemoteNowPlayingInfoArtist": information["kMRMediaRemoteNowPlayingInfoArtist"] as Any,
            "kMRMediaRemoteNowPlayingInfoTitle": information["kMRMediaRemoteNowPlayingInfoTitle"] as Any,
            "kMRMediaRemoteNowPlayingInfoAlbum": information["kMRMediaRemoteNowPlayingInfoAlbum"] as Any,
            "kMRMediaRemoteNowPlayingInfoArtworkData": information["kMRMediaRemoteNowPlayingInfoArtworkData"] as Any
        ])

        return NowPlayingItem(
            artist: artist ?? "Unknown Artist",
            title: title ?? "Unknown Title",
            album: album ?? "Unknown Album",
            artwork: artwork
        )
    }

    struct NowPlayingItem: Hashable, Equatable {
        var artist: String
        var title: String
        var album: String
        var artwork: NSImage?
    }
}
