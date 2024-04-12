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
    
    private var batteryService: BatteryService?
    
    @Published var notchHeight: CGFloat = 0
    @Published var notchWidth: CGFloat = 0
    
    @Published var batteryPercentage: CGFloat = 0
    @Published var isPowerSourceBattery = true
    @Published var batteryTimeRemaining: String = ""
    
    let CHARGING_THRESHOLD = 0.20
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Application did finish launching")
        
        do {
            try self.batteryService = BatteryService()
        } catch {
            batteryService = nil
        }
        
        self.updateBatteryInfo()
        
        NotificationCenter.default.addObserver(forName: .powerSourceChangedNotification, object: nil, queue: .main) { _ in
            self.updateBatteryInfo()
        }
        
    }
    
    func showPopup(title: String, description: String = "", seconds: Double = 2) {
        let notch = DynamicNotchInfo(
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
                description: "\(self.batteryTimeRemaining)"
            )
            
            // Adding 0.5 seconds makes this smoother because the app seems to freeze for
            // a split second when the power adapter is plugged in (This is a MacOS issue)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showPopup(
                    title: "Battery Percentage",
                    description: "\(self.batteryTimeRemaining)",
                    seconds: 5
                )
            }
        }
    }
}
