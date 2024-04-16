//
//  GeneralView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import SwiftUI
import Defaults

struct GeneralView: View{
    @Default(.launchAtLogin) var launchAtLogin
    @Default(.hideMenuIcon) var hideMenuIcon
    
    var body: some View{
        Form {
            Section {
                Toggle("Launch at login", isOn: $launchAtLogin)
                Toggle("Hide menubar icon", isOn: $hideMenuIcon)
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
