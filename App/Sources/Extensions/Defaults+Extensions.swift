//
//  Defaults+Extensions.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 15/4/24.
//

import SwiftUI
import Defaults

// Add variables for default values (which are stored even then the app is closed)
extension Defaults.Keys {
    static let automaticallyChecksForUpdates = Defaults.Key<Bool>("automaticallyChecksForUpdates", default: true)
    static let includeDevelopmentVersions = Defaults.Key<Bool>("includeDevelopmentVersions", default: false)
    static let launchAtLogin = Defaults.Key<Bool>("launchAtLogin", default: true)
    static let showDockIcon = Defaults.Key<Bool>("showDockIcon", default: false)
    static let slideTransition = Defaults.Key<Bool>("slideTransition", default: true)
    static let highContrast = Defaults.Key<Bool>("highContrast", default: false)
    static let currentStyle = Defaults.Key<String>("hideMenuIcon", default: "Automatic")
}
