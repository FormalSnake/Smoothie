//
//  BatteryMonitor.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI

class BatteryMonitor: MonitorProtocol {
    let CHARGING_THRESHOLD: Int = 20
    private var batteryService: BatteryService?
    @Published var lastBatteryPowerSource: PowerSource?
    
    func addObservers() {
        do {
            try self.batteryService = BatteryService()
            self.lastBatteryPowerSource = batteryService?.powerSource
        } catch {
            batteryService = nil
        }
        
        NotificationCenter.default.addObserver(
            forName: .powerSourceChangedNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.updateData()
        }
    }
    
    func updateData() {
        guard let batteryService = self.batteryService else {
            return
        }
        
        if batteryService.powerSource != self.lastBatteryPowerSource {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.show()
            }
        }
        // MARK: PLease look at this it doesnt really work :(
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let appDelegate = NSApp.delegate as? AppDelegate {
                if (batteryService.percentage ?? 100 <= self.CHARGING_THRESHOLD && batteryService.isCharging == false ) {
                    appDelegate.showPopup(
                        title: "Low Battery",
                        description: "Please charge to dismiss this warning.",
                        percentage: Double(batteryService.percentage ?? 0) / 100,
                        color: batteryService.percentage ?? 100 <= self.CHARGING_THRESHOLD ? .red : .green,
                        seconds: 99999999999
                    )
                }
            }
        }*/
    }
    
    func show() {
        guard let batteryService = self.batteryService else {
            return
        }
        
        let percentage = batteryService.percentage ?? 100
        let timeRemaining = batteryService.timeRemaining
        var title: String = batteryService.powerSource == .battery ? "Battery Percentage" : "Charging..."

        var description = String(
            format: "%d hours and %02d minutes Remaining",
            arguments: [(timeRemaining ?? 0) / 60, (timeRemaining ?? 0) % 60]
        )
        
        if timeRemaining == nil {
            description = "Calculating time remaining..."
        }
        
        if let charging = batteryService.isCharging,
           let plugged = batteryService.isPlugged,
           let charged = batteryService.isCharged {
            
            if charged, plugged {
                title = "Fully Charged!"
                description = "You can relax now"
            }
            
            if charging {
                title = "Charging"
                description = String(
                    format: "Fully Charged in %d hours and %02d",
                    arguments: [(timeRemaining ?? 0) / 60, (timeRemaining ?? 0) % 60]
                )
            }
        }

        // If battery percentage is < 20% and not being charged
        if percentage <= self.CHARGING_THRESHOLD && batteryService.isCharging == false {
            title = "Low Battery"
            description = "Please charge to dismiss this warning."
        }

        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.showPopup(
                title: title,
                description: description,
                percentage: Double(percentage) / 100,
                color: percentage < 20 ? .red : (percentage < 40 ? .orange : .green),
                seconds: percentage < 20 ? nil : 2
            )
        }
        
        self.lastBatteryPowerSource = batteryService.powerSource
    }
}
