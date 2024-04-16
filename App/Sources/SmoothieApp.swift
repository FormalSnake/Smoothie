//
//  SmoothieApp.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 11/4/24.
//

import SwiftUI
import Sparkle
import Defaults
import SettingsAccess

@main
struct SmoothieApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        MenuBarExtra("Smoothie", systemImage: "takeoutbag.and.cup.and.straw.fill") {
            Button("Audio Output Monitor") {
                appDelegate.audioOutputMonitor.show()
            }
            .keyboardShortcut("1", modifiers: .command)
            
            Button("Battery Monitor") {
                appDelegate.batteryMonitor.show()
            }
            .keyboardShortcut("2", modifiers: .command)
            
            Button("Now Playing Monitor") {
                appDelegate.nowPlayingMonitor.show()
            }
            .keyboardShortcut("3", modifiers: .command)
            
            Divider()
            
            SettingsLink(
                label: {
                    Text("Settings…")
                },
                preAction: {
                    for window in NSApp.windows where window.toolbar?.items != nil {
                        window.close()
                    }
                },
                postAction: {
                    for window in NSApp.windows where window.toolbar?.items != nil {
                        window.orderFrontRegardless()
                        window.center()
                    }
                }
            )
            .keyboardShortcut(",", modifiers: .command)
            
            Divider()
            
            Button(action: {
                NSApp.terminate(self)
            }, label: {
                Text("Quit")
            })
        }
        .menuBarExtraStyle(.menu)
    }
}

#Preview {
    SettingsView()
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        visualEffectView.isEmphasized = true
        return visualEffectView
    }
    
    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}