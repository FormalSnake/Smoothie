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
        MenuBarExtra("Smoothie", systemImage: "takeoutbag.and.cup.and.straw") {
            Button("Audio Output Monitor") {
                appDelegate.audioOutputMonitor.show()
            }

            Button("Battery Monitor") {
                appDelegate.batteryMonitor.show()
            }

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
