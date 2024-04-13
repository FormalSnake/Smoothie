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
        WindowGroup {
            SettingsView()
        }
        MenuBarExtra("Smoothie", systemImage: "takeoutbag.and.cup.and.straw.fill") {
            Button("Audio Output Monitor") {
                appDelegate.audioOutputMonitor.show()
            }
            
            Button("Battery Monitor") {
                appDelegate.batteryMonitor.show()
            }
            
            Button("Now Playing Monitor") {
                appDelegate.nowPlayingMonitor.show()
            }
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

struct SettingsView: View{
    var body: some View{
        NavigationView {
            List {
                NavigationLink(destination: SettingsBodyView()) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Sidebar")
            SettingsBodyView()
        }
    }
}

struct SettingsBodyView: View{
    @State var sample: Bool = false
    @State var currentStyle: String = "Automatic"
    var body: some View{
        Form{
            Section {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 704, height: 299)
                    .background(
                        AsyncImage(url: URL(string: "https://via.placeholder.com/704x299"))
                    )
                Toggle("Slide transition", isOn: $sample)
                Toggle("High contrast", isOn: $sample)
                Picker("Selected icon:", selection: $currentStyle) {
                    HStack{
                        Label("Automatic", systemImage: "gear")
                        Label("Notch", systemImage: "gear")
                        Label("Popup", systemImage: "gear")
                    }
                }
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(false)
    }
}

#Preview {
    SettingsView()
}
