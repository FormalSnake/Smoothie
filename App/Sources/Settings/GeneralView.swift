//
//  GeneralView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import SwiftUI
import Defaults
import KeyboardShortcuts

struct GeneralView: View{
    @Default(.launchAtLogin) var launchAtLogin
    @Default(.hideMenuIcon) var hideMenuIcon
    
    var body: some View{
        Form {
            Section {
                Label("Behaviour", systemImage: "menubar.dock.rectangle")
                Toggle("Launch at login", isOn: $launchAtLogin)
                Toggle("Hide menubar icon", isOn: $hideMenuIcon)
            }
            Section{
                Label("Shortcuts", systemImage: "keyboard")
                KeyboardShortcuts.Recorder("Audio output shortcut:", name: .triggerAudioOutput)
                KeyboardShortcuts.Recorder("Battery monitor shortcut:", name: .triggerBattery)
                KeyboardShortcuts.Recorder("Media player shortcut:", name: .triggerMediaPlayer)
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(false)
        .scrollContentBackground(.hidden)
        .background(
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    GeneralView()
}
