//
//  AppDelegate.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-11.
//

import SwiftUI
import SimplyCoreAudio
import DynamicNotchKit
import KeyboardShortcuts
import AVFoundation
var player: AVAudioPlayer?

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
    
    var dynamicNotch: DynamicNotch?
    var lastShownMonitor: MonitorProtocol?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.delegate = self
        NSApp.setActivationPolicy(.accessory) // Hides dock icon

        batteryMonitor.addObservers()
        audioOutputMonitor.addObservers()
        nowPlayingMonitor.addObservers()
        
        KeyboardShortcuts.onKeyDown(for: .triggerMediaPlayer) { [self] in
            nowPlayingMonitor.show()
        }
        KeyboardShortcuts.onKeyDown(for: .triggerBattery) { [self] in
            batteryMonitor.show()
        }
        KeyboardShortcuts.onKeyDown(for: .triggerAudioOutput) { [self] in
            audioOutputMonitor.show()
        }
    }
    
    func showPopup(title: String, description: String?, image: Image?, seconds: Double? = 2, sender: MonitorProtocol) {
        if let dynamicNotch = self.dynamicNotch,
           dynamicNotch.isVisible {
            dynamicNotch.hide()
        }
        
        dynamicNotch = DynamicNotchInfo(
            icon: image,
            title: title,
            description: description
        )

        lastShownMonitor = sender
        if let seconds = seconds {
            dynamicNotch?.show(for: seconds)
        } else {
            dynamicNotch?.show()
        }
    }
    
    func showPopup(title: String, description: String?, percentage: Double, color: Color = .accentColor, seconds: Double? = 2, sender: MonitorProtocol) {
        if let dynamicNotch = self.dynamicNotch,
           dynamicNotch.isVisible {
            dynamicNotch.hide()
        }
        
        let view = ProgressRing(to: .constant(percentage), color: color).overlay {
            Text("\(Int(percentage * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        
        lastShownMonitor = sender
        dynamicNotch = DynamicNotchInfo(
            iconView: view,
            title: title,
            description: description
        )
        
        if let seconds = seconds {
            dynamicNotch?.show(for: seconds)
        } else {
            dynamicNotch?.show()
        }
    }
}
