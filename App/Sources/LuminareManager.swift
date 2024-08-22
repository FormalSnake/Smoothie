//
//  LuminareManager.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-06-22.
//

import Luminare
import SwiftUI
import Defaults

class LuminareManager {
    static let generalConfiguration = SettingsTab("General", Image(systemName: "gearshape"), GeneralView())
    //static let appearanceConfiguration = SettingsTab("Appearance", Image(systemName: "paintbrush"), AppearanceView())
    static let updatesConfiguration = SettingsTab("Updates", Image(systemName: "shippingbox"), UpdateView())
    
    static var luminare: LuminareSettingsWindow?
    
    static func open() {
        if luminare == nil {
            luminare = LuminareSettingsWindow(
                [
                    .init([
                        generalConfiguration,
                        //appearanceConfiguration,
                        updatesConfiguration,
                    ])
                    
                ],
                tint: {
                    Color.accentColor
                },
                didTabChange: {_ in},
                showPreviewIcon: Image(systemName: "takeoutbag.and.cup.and.straw.fill"),
                hidePreviewIcon: Image(systemName: "takeoutbag.and.cup.and.straw.fill")
            )
            DispatchQueue.main.async {
                luminare?.addPreview(
                    content: NotchlessView(),
                    identifier: "Preview",
                    fullSize: true
                )
                
                luminare?.showPreview(identifier: "Preview")
            }
        }
        luminare?.show()
        AppDelegate.isActive = true
        NSApp.setActivationPolicy(.regular)
    }
    
    static func fullyClose() {
        luminare?.close()
        luminare = nil
        
        if !Defaults[.showDockIcon] {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
