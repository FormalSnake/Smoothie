//
//  NowPlayingMonitor+NowPlayingItem.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-15.
//

import SwiftUI

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
