//
//  AppDelegate.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-11.
//

import SwiftUI
import SimplyCoreAudio
import DynamicNotchKit

// An app delegate is where you can handle application-level events
// Useful to set up monitoring for each notch module :D
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {

    static var shared: AppDelegate? {
        if let delegate = NSApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        return nil
    }

    let batteryMonitor = BatteryMonitor()
    let audioOutputMonitor = AudioOutputMonitor()

    private var dynamicNotch: DynamicNotch?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.delegate = self

        batteryMonitor.addObservers()
        audioOutputMonitor.addObservers()
    }
    
    func showPopup(title: String, description: String = "", seconds: Double = 2, image: String = "figure") {
        if let dynamicNotch = self.dynamicNotch,
           dynamicNotch.isVisible {
            dynamicNotch.hide()
        }

        dynamicNotch = DynamicNotchInfo(
            systemImage: image,
            title: title,
            description: description
        )

        dynamicNotch?.show(for: seconds)
    }
}
