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
import Luminare

struct GeneralView: View{
    //@Default(.launchAtLogin) var launchAtLogin
    @Default(.hideMenuIcon) var hideMenuIcon
    
    var body: some View{
        LuminareSection("Behaviour") {
            //LuminareToggle("Launch at login", isOn: $launchAtLogin)
            LaunchAtLogin.Toggle("Launch at login")
            LuminareToggle("Hide menubar icon", isOn: $hideMenuIcon)
        }
        LuminareSection("Shortcuts"){
            HStack {
                Text("Audio output shortcut")
                Spacer()
                KeyboardShortcuts.Recorder(for: .triggerAudioOutput)
            }
            .frame(height: 34)
            .padding(.horizontal, 8)

            HStack {
                Text("Battery monitor shortcut")
                Spacer()
                KeyboardShortcuts.Recorder(for: .triggerBattery)
            }
            .frame(height: 34)
            .padding(.horizontal, 8)

            HStack {
                Text("Media player shortcut")
                Spacer()
                KeyboardShortcuts.Recorder(for: .triggerMediaPlayer)
            }
            .frame(height: 34)
            .padding(.horizontal, 8)
        }
    }
}

#Preview {
    GeneralView()
}
