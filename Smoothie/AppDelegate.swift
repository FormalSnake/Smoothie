//
//  AppDelegate.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-11.
//

import SwiftUI
import DynamicNotchKit

// An app delegate is where you can handle application-level events
// Useful to set up monitoring for each notch module :D
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Application did finish launching")
    }

    func showPopup(_ title: String) {
        let notch = DynamicNotchInfo(
            title: title
        )
        notch.show(for: 2)
    }

}
