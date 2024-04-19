//
//  AudioOutputMonitor.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI
import SimplyCoreAudio

class AudioOutputMonitor: MonitorProtocol {
    private var lastDevice: AudioDevice?
    private let sca = SimplyCoreAudio()

    func addObservers() {
        self.lastDevice = sca.defaultOutputDevice

        NotificationCenter.default.addObserver(forName: .defaultOutputDeviceChanged, object: nil, queue: .main) { _ in
            self.updateData()
        }
    }

    func updateData() {
        guard let defaultOutputDevice = sca.defaultOutputDevice else { return }

        if defaultOutputDevice != self.lastDevice {
            self.show()
        }
    }

    func show() {
        guard let defaultOutputDevice = sca.defaultOutputDevice else { return}

        var outputImage = "cable.coaxial"
        
        if defaultOutputDevice.name.lowercased().contains("buds") {
            outputImage = "earbuds"
        }
        if defaultOutputDevice.name.lowercased().contains("ear") {
            outputImage = "earbuds"
        }
        if defaultOutputDevice.name.lowercased().contains("pods") {
            outputImage = "earbuds"
        }
        if defaultOutputDevice.name.lowercased().contains("headphones") {
            outputImage = "headphones"
        }

        self.lastDevice = defaultOutputDevice

        if let appDelegate = AppDelegate.shared {
            appDelegate.showPopup(
                title: defaultOutputDevice.name,
                description: "Connected",
                image: Image(systemName: outputImage),
                sender: self
            )
        }
    }
}
