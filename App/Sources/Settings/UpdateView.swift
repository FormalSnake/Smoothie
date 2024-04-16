//
//  UpdateView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import SwiftUI
import Defaults
import Sparkle

struct UpdateView: View{
    @Default(.automaticallyChecksForUpdates) var automaticallyChecksForUpdates
    @Default(.includeDevelopmentVersions) var includeDevelopmentVersions
    
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
                                localized: "Current version: \(Bundle.main.buildNumber)"
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
                        //updater.checkForUpdates()
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
