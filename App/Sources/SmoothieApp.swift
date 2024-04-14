//
//  SmoothieApp.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 11/4/24.
//

import SwiftUI
import Sparkle

@main
struct SmoothieApp: App {
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
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
                    destination: GeneralView(),
                    tag: 0,
                    selection: $selection
                ) {
                    Label("General", image: "general")
                }
                NavigationLink(
                    destination: AppearanceView(),
                    tag: 1,
                    selection: $selection
                ) {
                    Label("Appearance", image: "appearance")
                }
                NavigationLink(
                    destination: UpdateView(),
                    tag: 2,
                    selection: $selection
                ) {
                    Label("Updates", image: "updates")
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

struct AppearanceView: View{
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

struct GeneralView: View{
    @State var launchAtLogin: Bool = true
    @State var hideMenuIcon: Bool = false
    
    var body: some View{
        Form {
            Section {
                Toggle("Launch at login", isOn: $launchAtLogin)
                Toggle("Hide menubar icon", isOn: $hideMenuIcon)
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

struct UpdateView: View{
    @EnvironmentObject var updater: SoftwareUpdater
    @State var automaticallyChecksForUpdates: Bool = true
    @State var includeDevelopmentVersions: Bool = false
    
    var body: some View{
        Form {
            Section(content: {
                Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
                Toggle("Include development versions", isOn: $includeDevelopmentVersions)
            }, header: {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Updates")
                        Button(action: {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(
                                "Version",
                                forType: NSPasteboard.PasteboardType.string
                            )
                        }, label: {
                            let versionText = String(
                                localized: "Current version:)"
                            )
                            HStack {
                                Text("\(versionText) \(Image(systemName: "doc.on.clipboard"))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        })
                        .buttonStyle(.plain)
                    }
                    
                    Spacer()
                    
                    Button("Check for Updates…") {
                        updater.checkForUpdates()
                    }
                    .buttonStyle(.link)
                    .foregroundStyle(Color.accentColor)
                }
            })
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
