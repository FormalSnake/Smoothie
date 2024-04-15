//
//  NowPlayingMonitor+Private.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-15.
//

import SwiftUI

extension NowPlayingMonitor {
    var mediaRemoteBundle: CFBundle {
        CFBundleCreate(
          kCFAllocatorDefault,
          NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework")
        )
    }

    func getNowPlayingItem(from information: [String: Any]) -> NowPlayingMonitor.NowPlayingItem? {
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

        let nowPlayingItem = NowPlayingMonitor.NowPlayingItem(
            artist: artist,
            title: title,
            album: album,
            artwork: image
        )

        return nowPlayingItem
    }

    func getMRMediaRemoteRegisterForNowPlayingNotificationsFunction() -> @convention(c) (DispatchQueue) -> Void {
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

    func getMRMediaRemoteGetNowPlayingInfoFunction() -> @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void {
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
