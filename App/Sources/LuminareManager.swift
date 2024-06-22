//
//  LuminareManager.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-06-22.
//

import Luminare
import SwiftUI

class LuminareManager {
    static var window: NSWindow? {
        LuminareManager.luminare.windowController?.window
    }

    static let generalConfiguration = SettingsTab("General", Image(systemName: "gearshape"), GeneralView())
    static let appearanceConfiguration = SettingsTab("Appearance", Image(systemName: "paintbrush"), AppearanceView())
    static let updatesConfiguration = SettingsTab("Updates", Image(systemName: "shippingbox"), UpdateView())

    static var luminare = LuminareSettingsWindow(
        [
            .init([
                generalConfiguration,
                appearanceConfiguration,
                updatesConfiguration
            ]),
            .init([
                generalConfiguration,
                appearanceConfiguration,
                updatesConfiguration
            ]),
            .init([
                generalConfiguration,
                appearanceConfiguration,
                updatesConfiguration
            ])
        ],
        tint: { Color.yellow },
        didTabChange: { _ in }
    )

    static func open() {
        if luminare.windowController == nil {
            luminare.initializeWindow()
        }

        luminare.show()
        NSApp.setActivationPolicy(.regular)
    }

    static func fullyClose() {
        luminare.deinitWindow()
        NSApp.setActivationPolicy(.accessory)
    }
}
