//
//  NowPlayingView.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI

struct NowPlayingView: View {
    @State var artwork: NSImage?
    @State var title: String = ""
    @State var description: String?

    init(_ item: NowPlayingMonitor.NowPlayingItem) {
        self._artwork = State(initialValue: item.artwork)
        self._title = State(initialValue: item.title)
        self._description = State(initialValue: "\(item.album)")
    }

    var body: some View {
        HStack {
            ZStack {
                if let artwork = self.artwork {
                    Image(nsImage: artwork)
                        .resizable()
                        .frame(width: 50, height: 50)
                } else {
                    ProgressView()
                }
            }
            .clipShape(.rect(cornerRadius: 10))

            Spacer()
                .frame(width: 10)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)

                if let description = description {
                    Text(description)
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                }
            }

            Spacer()
        }
        .padding(10)
        .onReceive(.nowPlayingChanged) { obj in
            if let userInfo = obj.userInfo {

                if let album = userInfo["kMRMediaRemoteNowPlayingInfoAlbum"] {
                    self.description = "\(album as? String ?? "")"
                }

                if let info = userInfo["kMRMediaRemoteNowPlayingInfoTitle"] {
                    self.title = info as? String ?? ""
                }

                if let info = userInfo["kMRMediaRemoteNowPlayingInfoArtworkData"],
                   let artworkData = info as? Data {

                    self.artwork = NSImage(data: artworkData) ?? NSImage()
                }
            }
        }
    }
}
