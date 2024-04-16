//
//  AppearanceView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import SwiftUI
import Defaults

struct AppearanceView: View{
    @Default(.slideTransition) var slideTransition
    @Default(.highContrast) var highContrast
    @Default(.currentStyle) var currentStyle

    var body: some View{
        Form {
            Section {
                AsyncImage(url: URL(string: "https://via.placeholder.com/704x299"))
                    .aspectRatio(contentMode: .fill)
                
                Toggle("Slide transition", isOn: $slideTransition)
                Toggle("High contrast", isOn: $highContrast)
                Picker("Selected icon:", selection: $currentStyle) {
                    HStack{
                        Label("Automatic", systemImage: "gear")
                        Label("Notch", systemImage: "gear")
                        Label("Popup", systemImage: "gear")
                    }
                }
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
