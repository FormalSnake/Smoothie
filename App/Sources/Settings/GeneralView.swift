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
    @Default(.launchAtLogin) var launchAtLogin
    @Default(.hideMenuIcon) var hideMenuIcon
    
    var body: some View{
        LuminareSection("Behaviour") {
            LuminareToggle("Launch at login", isOn: $launchAtLogin)
            LuminareToggle("Hide menubar icon", isOn: $hideMenuIcon)
        }
        LuminareSection("Shortcuts"){
            KeyboardShortcuts.Recorder("Audio output shortcut:", name: .triggerAudioOutput)
            KeyboardShortcuts.Recorder("Battery monitor shortcut:", name: .triggerBattery)
            KeyboardShortcuts.Recorder("Media player shortcut:", name: .triggerMediaPlayer)
        }
    }
}

#Preview {
    GeneralView()
}
