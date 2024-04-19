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
                Spacer()

                if !nowPlayingItem.album.isEmpty && !nowPlayingItem.album.contains(nowPlayingItem.title) {
                    AutoScrollingText(text: "\(nowPlayingItem.title) - \(nowPlayingItem.album)", font: .headline)
                } else {
                    AutoScrollingText(text: "\(nowPlayingItem.title)", font: .headline)
                }
                
                Text(nowPlayingItem.artist)
                    .foregroundStyle(.secondary)
                    .font(.caption2)

                Spacer()
            }
            .frame(minWidth: 120)

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
                
                withAnimation {
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
}

struct AutoScrollingText: View {
    let text: String
    let font: Font

    @State private var scrollOffset = 20.0
    @State private var scrollSize = CGSize.zero
    @State private var timer: Timer?
    
    var body: some View {
        if text.count >= 20 {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(text)
                        .font(font)
                        .background {
                            GeometryReader { textGeometry -> Color in
                                DispatchQueue.main.async {
                                    if self.scrollSize.width != textGeometry.size.width {
                                        self.scrollSize = textGeometry.size
                                        self.startScrolling(geometry: geometry)
                                    }
                                }
                                return Color.clear
                            }
                        }
                        .offset(x: self.scrollOffset)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        } else {
            Text(text)
                .font(font)
        }
    }
    
    private func startScrolling(geometry: GeometryProxy) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1/30.0, repeats: true) { _ in
            withAnimation {
                self.scrollOffset -= 1
            }

            // Reset
            if self.scrollOffset <= -self.scrollSize.width {
                self.scrollOffset = geometry.size.width
            }
        }
    }
}
