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
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)

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

struct SettingsView: View {
    @State private var selection: Int? = 0

    var body: some View {
        NavigationView {
            List(selection: $selection) {
                NavigationLink(
                    destination: SettingsBodyView(),
                    tag: 0,
                    selection: $selection
                ) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .background(
                VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                    .ignoresSafeArea()
            )
            .listStyle(SidebarListStyle())
            .navigationTitle("Sidebar")
            .frame(minWidth: 200)
        }
        .frame(width: 1000, height: 680)
        .fixedSize()
    }
}

struct SettingsBodyView: View{
    @State var sample: Bool = false
    @State var currentStyle: String = "Automatic"
    var body: some View{
        Form {
            Section {
                AsyncImage(url: URL(string: "https://via.placeholder.com/704x299"))
                    .aspectRatio(contentMode: .fill)

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
        .scrollContentBackground(.hidden)
        .background(
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                .ignoresSafeArea()
        )
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
