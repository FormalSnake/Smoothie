//
//  Bundle+Extensions.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation


extension Bundle {
    var appName: String {
        getInfo("CFBundleName") ?? "⚠️"
    }
    
    var displayName: String {
        getInfo("CFBundleDisplayName") ?? "⚠️"
    }
    
    var bundleID: String {
        getInfo("CFBundleIdentifier") ?? "⚠️"
    }
    
    var copyright: String {
        getInfo("NSHumanReadableCopyright") ?? "⚠️"
    }
    
    var appBuild: Int? {
        Int(getInfo("CFBundleVersion") ?? "")
    }
    
    var appVersion: String? {
        getInfo("CFBundleShortVersionString")
    }
    
    func getInfo(_ str: String) -> String? {
        infoDictionary?[str] as? String
    }
}
