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
import Luminare

class AboutConfigurationModel: ObservableObject {
    @Published var isHoveringOverVersionCopier = false
    
    @Published var includeDevelopmentVersions = Defaults[.includeDevelopmentVersions] {
        didSet {
            Defaults[.includeDevelopmentVersions] = includeDevelopmentVersions
        }
    }
    
    @Published var updateButtonTitle: LocalizedStringKey = "Check for updates…"
    
    let credits: [CreditItem] = [
            .init(
                "Kai",
                "Development",
                url: .init(string: "https://github.com/mrkai77")!,
                avatar: Image(.kai)
            ),
            .init(
                "Kyan",
                "Development",
                url: .init(string: "https://x.com/formalsnake")!,
                avatar: Image(.kyan)
            ),
        ]
    
    let upToDateText: [LocalizedStringKey] = [
        "All systems are fully operational.",
        "No new data from Starfleet.",
        "You’re already in hyperspace!",
        "Await further instructions.",
        "These aren't the updates you're looking for.",
        "Stay vigilant, more intel inbound!",
        "May the Force be with you... next time!",
        "The Force is strong with this version!",
        "You’ve reached the event horizon!",
        "You’ve got the precious, no updates needed!",
        "No new intel, Commander."
    ]
    
    func copyVersionToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(
            //"Version \(Bundle.main.appVersion) (\(Bundle.main.appBuild))",
            "Oi why are you disrespecting me bruv??",
            forType: NSPasteboard.PasteboardType.string
        )
    }
}

struct CreditItem: Identifiable {
    var id: String { name }

    let name: String
    let description: LocalizedStringKey?
    let url: URL
    let avatar: Image

    init(_ name: String, _ description: LocalizedStringKey? = nil, url: URL, avatar: Image) {
        self.name = name
        self.description = description
        self.avatar = avatar
        self.url = url
    }
}

struct UpdateView: View{
    @Environment(\.openURL) private var openURL
    @StateObject private var model = AboutConfigurationModel()
    //@ObservedObject private var updater = AppDelegate.updater
    
    var body: some View{
        LuminareSection {
            Button {
                model.copyVersionToClipboard()
            } label: {
                HStack {
                    if let image = NSImage(named: "AppIcon") {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Loop")
                            .fontWeight(.medium)
                        
                        Text(
                            //"Version \(Bundle.main.appVersion) (\(Bundle.main.appBuild))"
                            "Version idk (what did u expect)"
                        )
                        .contentTransition(.numericText(countsDown: !model.isHoveringOverVersionCopier))
                        .animation(.smooth(duration: 0.25), value: model.isHoveringOverVersionCopier)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(4)
            }
            .buttonStyle(LuminareCosmeticButtonStyle(Image(systemName: "clipboard")))
            .onHover {
                model.isHoveringOverVersionCopier = $0
            }
        }
        LuminareSection {
            Button {
                Task {
                    /*await updater.fetchLatestInfo()
                     
                     if updater.updateState == .available {
                     updater.showUpdateWindow()
                     } else {*/
                    model.updateButtonTitle = model.upToDateText.randomElement()!
                    
                    let currentTitle = model.updateButtonTitle
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if model.updateButtonTitle == currentTitle {
                            model.updateButtonTitle = "Check for updates…"
                        }
                    }
                    //}
                }
            } label: {
                Text(model.updateButtonTitle)
                    .contentTransition(.numericText())
                    .animation(.smooth(duration: 0.25), value: model.updateButtonTitle)
            }
        }
        LuminareSection("Credits") {
                   ForEach(model.credits) { credit in
                       creditsView(credit)
                   }
               }
    }
    
    @ViewBuilder
        func creditsView(_ credit: CreditItem) -> some View {
            Button {
                openURL(credit.url)
            } label: {
                HStack(spacing: 12) {
                    credit.avatar
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                        .overlay {
                            Circle()
                                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                        }
                        .clipShape(.circle)

                    VStack(alignment: .leading) {
                        Text(credit.name)

                        if let description = credit.description {
                            Text(description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()
                }
                .padding(12)
            }
            .buttonStyle(LuminareCosmeticButtonStyle(Image(systemName: "square.and.arrow.up")))
        }
}

#Preview {
    UpdateView()
}
