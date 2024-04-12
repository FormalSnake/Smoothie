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

    private var currentOutputDevice: AudioDevice?
    private let sca = SimplyCoreAudio()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Application did finish launching")
        updateAudioDevice()
        
        do {
            try self.batteryService = BatteryService()
        } catch {
            batteryService = nil
        }
        
        self.updateBatteryInfo()
        
        NotificationCenter.default.addObserver(forName: .powerSourceChangedNotification, object: nil, queue: .main) { _ in
            self.updateBatteryInfo()
        }
        
        NotificationCenter.default.addObserver(forName: .defaultOutputDeviceChanged, object: nil, queue: .main) { (_) in
            self.updateAudioDevice()
        }
    }
    
    func showPopup(title: String, description: String = "", seconds: Double = 2, image: String = "figure") {
        let notch = DynamicNotchInfo(
            systemImage: image,
            title: title,
            description: description
        )
        notch.show(for: seconds)
    }
    

    private var batteryService: BatteryService?
    @Published var lastBatteryPowerSource: PowerSource?

    func updateBatteryInfo() {
        guard let batteryService = self.batteryService else {
            return
        }
        

        if batteryService.powerSource != self.lastBatteryPowerSource {

            let percentage = batteryService.percentage
            var description = String(
                format: "%d:%02d Remaining",
                arguments: [(percentage ?? 0) / 60, (percentage ?? 0) % 60]
            )

            if percentage == nil {
                description = "Calculating time remaining..."
            }

            if let charging = batteryService.isCharging,
               let plugged = batteryService.isPlugged,
               let charged = batteryService.isCharged {

                if charged, plugged {
                    description = "Fully Charged!"
                }

                if charging {
                    description = "Charging"
                }
            }

            self.showPopup(
                title: "Battery Percentage",
                description: description,
                seconds: 2
            )
        }
    }
    
    func updateAudioDevice() {
        guard let defaultOutputDevice = sca.defaultOutputDevice else { return}
        
        self.currentOutputDevice = defaultOutputDevice
        
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
        
        self.showPopup(title: defaultOutputDevice.name, description: "CONNECTED", seconds: 2, image: outputImage)
    }
}
