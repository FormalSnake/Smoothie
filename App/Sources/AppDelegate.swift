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
    let nowPlayingMonitor = NowPlayingMonitor()
    let bluetoothMonitor = BluetoothMonitor()

    var dynamicNotch: DynamicNotch?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.delegate = self

        batteryMonitor.addObservers()
        audioOutputMonitor.addObservers()
        nowPlayingMonitor.addObservers()
        //bluetoothMonitor.addObservers()
    }
    
    func showPopup(title: String, description: String?, image: Image?, seconds: Double = 2) {
        if let dynamicNotch = self.dynamicNotch,
           dynamicNotch.isVisible {
            dynamicNotch.hide()
        }

        dynamicNotch = DynamicNotchInfo(
            icon: image,
            title: title,
            description: description
        )

        dynamicNotch?.show(for: seconds)
    }

    func showPopup(title: String, description: String?, percentage: Double, color: Color = .accentColor, seconds: Double = 2) {
        if let dynamicNotch = self.dynamicNotch,
           dynamicNotch.isVisible {
            dynamicNotch.hide()
        }

        let view = ProgressRing(to: .constant(percentage), color: color).overlay {
            Text("\(Int(percentage * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }

        dynamicNotch = DynamicNotchInfo(
            iconView: view,
            title: title,
            description: description
        )

        dynamicNotch?.show(for: seconds)
    }
}
