//
//  SmoothieApp.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 11/4/24.
//

import SwiftUI

@main
struct SmoothieApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Battery Monitor", systemImage: "minus.plus.batteryblock.fill") {
                    Button(action: {
                        appDelegate.updateBatteryInfo()

                            appDelegate.showPopup(
                                title: "Battery Percentage",
                                description: "\(appDelegate.batteryTimeRemaining)",
                                seconds: 2
                            )
                    },
                           label: {
                        Text("Trigger")
                    })
                    Button(action: {
                        NSApp.terminate(self)
                    }, label: {
                        Text("Quit")
                    })
                }
                .menuBarExtraStyle(.menu)
        WindowGroup {
            ContentView(appDelegate: appDelegate)
        }
    }
}
