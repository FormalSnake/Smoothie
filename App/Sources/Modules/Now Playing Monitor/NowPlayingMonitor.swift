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
        let MRMediaRemoteRegisterForNowPlayingNotifications = getMRMediaRemoteRegisterForNowPlayingNotificationsFunction()

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "kMRMediaRemoteNowPlayingInfoDidChangeNotification"),
            object: nil,
            queue: nil
        ) { _ in
            self.updateData()
        }

        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main)

        self.updateData()
    }
    
    func updateData() {
        let MRMediaRemoteGetNowPlayingInfo = getMRMediaRemoteGetNowPlayingInfoFunction()
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main) { information in
            let newItem = self.getNowPlayingItem(information)

            if let newItem = newItem,
               newItem.isDifferentSong(from: self.nowPlayingItem) {

                print("TEATR")
                self.nowPlayingItem = newItem
                self.show()
            }

            // If the now playing view is open, this notification will update it.
            NotificationCenter.default.post(name: .nowPlayingChanged, object: newItem)
        }
    }
    
    func show() {
        guard let item = nowPlayingItem else { return }

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

extension NowPlayingMonitor {
    private var mediaRemoteBundle: CFBundle {
        CFBundleCreate(
          kCFAllocatorDefault,
          NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework")
        )
    }

    private func getNowPlayingItem(_ information: [String: Any]) -> NowPlayingMonitor.NowPlayingItem? {
        guard
            let artist = information["kMRMediaRemoteNowPlayingInfoArtist"] as? String,
            let title = information["kMRMediaRemoteNowPlayingInfoTitle"] as? String,
            let album = information["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
        else {
            return nil
        }

        // Image is optional
        var image: NSImage?
        if let data = information["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
            image = NSImage(data: data)
        }

        var nowPlayingItem: NowPlayingMonitor.NowPlayingItem? = NowPlayingMonitor.NowPlayingItem(
            artist: artist,
            title: title,
            album: album,
            artwork: image
        )

        return nowPlayingItem
    }

    private func getMRMediaRemoteRegisterForNowPlayingNotificationsFunction() -> @convention(c) (DispatchQueue) -> Void {
        let bundle = mediaRemoteBundle

        guard let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString) else {
            fatalError("Could not find MRMediaRemoteRegisterForNowPlayingNotifications")
        }

        typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void

        let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(
            MRMediaRemoteRegisterForNowPlayingNotificationsPointer,
            to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self
        )

        return MRMediaRemoteRegisterForNowPlayingNotifications
    }

    private func getMRMediaRemoteGetNowPlayingInfoFunction() -> @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void {
        let bundle = mediaRemoteBundle

        guard let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString) else {
            fatalError("Could not find MRMediaRemoteGetNowPlayingInfo")
        }

        typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void

        let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(
            MRMediaRemoteGetNowPlayingInfoPointer,
            to: MRMediaRemoteGetNowPlayingInfoFunction.self
        )

        return MRMediaRemoteGetNowPlayingInfo
    }
}

extension NowPlayingMonitor {
    struct NowPlayingItem: Hashable, Equatable {
        var artist: String
        var title: String
        var album: String
        var artwork: NSImage?

        func isDifferentSong(from other: NowPlayingItem?) -> Bool {
            guard let other = other else { return true }

            return
                self.artist != other.artist &&
                self.title != other.title &&
                self.album != other.album
        }
    }
}
