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
    private var batteryService: BatteryService?
    
    private var currentOutputDevice: AudioDevice?
    private let sca = SimplyCoreAudio()
    
    @Published var notchHeight: CGFloat = 0
    @Published var notchWidth: CGFloat = 0
    
    @Published var batteryPercentage: CGFloat = 0
    @Published var isPowerSourceBattery = true
    @Published var batteryTimeRemaining: String = ""
    
    let CHARGING_THRESHOLD = 0.20
    
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
    
    func updateBatteryInfo() {
        var overrideWillShowPopup = false
        
        guard let batteryService = self.batteryService else {
            return
        }
        
        // Show popup when the power cable is plugged in/out
        if self.isPowerSourceBattery != (batteryService.powerSource != .powerAdapter) {
            overrideWillShowPopup = true
        }
        
        self.isPowerSourceBattery = batteryService.powerSource != .powerAdapter
        self.batteryTimeRemaining = batteryService.timeRemaining.formatted
        self.batteryPercentage = CGFloat(batteryService.percentage.numeric ?? 0)/100
        
        if (batteryPercentage <= CHARGING_THRESHOLD && isPowerSourceBattery) {
            self.showPopup(
                title: "Low Battery",
                description: "Please charge this MacBook to dismiss this warning."
            )
        } else if overrideWillShowPopup {
            self.showPopup(
                title: "Battery Percentage",
                description: "\(self.batteryTimeRemaining)",
                seconds: 5
            )
            
            // Adding 0.5 seconds makes this smoother because the app seems to freeze for
            // a split second when the power adapter is plugged in (This is a MacOS issue)
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             self.showPopup(
             title: "Battery Percentage",
             description: "\(self.batteryTimeRemaining)",
             seconds: 5
             )
             }*/
        }
    }
    
    func updateAudioDevice() {
        guard let defaultOutputDevice = sca.defaultOutputDevice else { return}
        
        self.currentOutputDevice = defaultOutputDevice
        
        var outputImage = "cable.coaxial"
        
        if defaultOutputDevice.name.lowercased().contains("buds") {
            outputImage = "earbuds"
        }
        if defaultOutputDevice.name.lowercased().contains("headphones") {
            outputImage = "headphones"
        }
        
        self.showPopup(title: defaultOutputDevice.name, description: "CONNECTED", seconds: 2, image: outputImage)
    }
}
