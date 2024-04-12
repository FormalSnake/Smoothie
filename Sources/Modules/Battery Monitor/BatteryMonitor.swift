//
//  BatteryMonitor.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI

class BatteryMonitor: MonitorProtocol {

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
            self.show()
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
    }

    func show() {
        guard let batteryService = self.batteryService else {
            return
        }

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

        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.showPopup(
                title: "Battery Percentage",
                description: description,
                percentage: Double(percentage ?? 0) / 100,
                color: percentage ?? 0 < 20 ? .red : .green
            )
        }

        self.lastBatteryPowerSource = batteryService.powerSource
    }
}
