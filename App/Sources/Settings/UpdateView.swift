//
//  UpdateView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import SwiftUI
import Defaults
import Sparkle
import Luminare

struct UpdateView: View{
    @Default(.automaticallyChecksForUpdates) var automaticallyChecksForUpdates
    @Default(.includeDevelopmentVersions) var includeDevelopmentVersions
    
    var body: some View{
        LuminareSection("Behaviour") {
            LuminareToggle(
                "Automatically check for updates",
                isOn: $automaticallyChecksForUpdates
            )
            LuminareToggle("Include development versions", isOn: $includeDevelopmentVersions)
            }
    }
}

#Preview {
    UpdateView()
}
