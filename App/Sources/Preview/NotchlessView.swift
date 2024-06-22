//
//  NotchlessView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 22/6/24.
//
import SwiftUI

struct NotchlessView: View {
    @State var isMouseInside: Bool = true
    @State var isVisible: Bool = false
    @State var windowHeight: CGFloat = 563
    @State var notchHeight: CGFloat = 100
    var nowPlayingItem: NowPlayingMonitor.NowPlayingItem
    
    init() {
        self.nowPlayingItem = NowPlayingMonitor.NowPlayingItem(
            artist: "Rick Astley",
            title: "Never Gonna Give You Up",
            album: "Whenever You Need Somebody",
            artwork: NSImage(named: "rick"),
            isPlaying: true
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                NowPlayingView(nowPlayingItem)
                    .fixedSize()
                
                    .background {
                        VisualEffectView(material: .popover, blendingMode: .behindWindow)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .strokeBorder(.quaternary, lineWidth: 1)
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.5), radius: isVisible ? 10 : 0)
                    .padding(20)
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    windowHeight = geo.size.height
                                }
                        }
                    }
                    .offset(y: isVisible ? notchHeight : -windowHeight)
                
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            withAnimation {
                isVisible.toggle()
            }
        }
    }
}

struct NotchlessView_Previews: PreviewProvider {
    static var previews: some View {
        NotchlessView()
    }
}
