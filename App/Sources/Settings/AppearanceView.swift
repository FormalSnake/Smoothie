//
//  AppearanceView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import SwiftUI
import Defaults
import Luminare

struct AppearanceView: View{
    @Default(.slideTransition) var slideTransition
    @Default(.highContrast) var highContrast
    @Default(.currentStyle) var currentStyle

    var body: some View{
        LuminareSection {
                AsyncImage(url: URL(string: "https://via.placeholder.com/704x299"))
                    .aspectRatio(contentMode: .fill)
                
            LuminareToggle("Slide transition", isOn: $slideTransition)
            LuminareToggle("High contrast", isOn: $highContrast)
                Picker("Selected icon:", selection: $currentStyle) {
                    HStack{
                        Label("Automatic", systemImage: "gear")
                        Label("Notch", systemImage: "gear")
                        Label("Popup", systemImage: "gear")
                    }
                }
            }
        }
}

#Preview {
    AppearanceView()
}
