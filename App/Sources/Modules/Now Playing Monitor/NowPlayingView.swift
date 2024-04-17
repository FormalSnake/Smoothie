//
//  NowPlayingView.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI
import PrivateMediaRemote

struct NowPlayingView: View {
    @State var nowPlayingItem: NowPlayingMonitor.NowPlayingItem

    init(_ item: NowPlayingMonitor.NowPlayingItem) {
        self._nowPlayingItem = State(initialValue: item)
    }

    var body: some View {
        HStack {
            ZStack {
                if let artwork = nowPlayingItem.artwork {
                    Image(nsImage: artwork)
                        .resizable()
                        .frame(width: 50, height: 50)
                } else {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            }
            .clipShape(.rect(cornerRadius: 10))

            Spacer()
                .frame(width: 10)

            VStack(alignment: .leading) {
                Text(nowPlayingItem.title)
                    .font(.headline)

                Text(nowPlayingItem.album)
                    .foregroundStyle(.secondary)
                    .font(.caption2)
            }

            Spacer()

            Button {
                MRMediaRemoteSendCommand(MRMediaRemoteCommandTogglePlayPause, [:])
            } label: {
                if #available(macOS 14.0, *) {
                    Image(systemName: self.nowPlayingItem.isPlaying ?  "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .contentTransition(.symbolEffect(.replace, options: .speed(1.5)))
                } else {
                    Image(systemName: self.nowPlayingItem.isPlaying ?  "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                }
            }
            .frame(width: 20)
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 10)
        }
        .padding(10)
        .onReceive(.nowPlayingChanged) { notification in
            if let object = notification.object,
               let item = object as? NowPlayingMonitor.NowPlayingItem {

                self.nowPlayingItem = NowPlayingMonitor.NowPlayingItem(
                    artist: item.artist,
                    title: item.title,
                    album: item.album,
                    artwork: item.artwork ?? self.nowPlayingItem.artwork,
                    isPlaying: item.isPlaying
                )
            }
        }
    }
}
