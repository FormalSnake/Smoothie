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
        "All systems are at Red Alert, ready for action!",
        "No new data from Starfleet Command.",
        "You're already at warp speed!",
        "Awaiting further orders from the bridge.",
        "These aren't the updates you're looking for.",
        "Stay vigilant, more signals from Starfleet are incoming!",
        "May the Force guide your next mission!",
        "I'm afraid I cannot do that, Dave.",
        "You've crossed the event horizon, no turning back!",
        "You’ve got the monolith, no updates required!",
        "No new intel, Captain."
    ]
    
    func copyVersionToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(
            "Version \(Bundle.main.appVersion ?? "Unknown") (\(Bundle.main.appBuild ?? 0))",
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

// This view model class publishes when new updates can be checked by the user
final class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdates = false
    
    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }
}

// This is the view for the Check for Updates menu item
// Note this intermediate view is necessary for the disabled state on the menu item to work properly before Monterey.
// See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more info
struct CheckForUpdatesView: View {
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater
    @StateObject private var model = AboutConfigurationModel()
    
    init(updater: SPUUpdater) {
        self.updater = updater
        
        // Create our view model for our CheckForUpdatesView
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
    }
    
    var body: some View {
        Button {
            
            Task {
                /*await updater.fetchLatestInfo()
                 
                 if updater.updateState == .available {
                 updater.showUpdateWindow()
                 } else {*/
                updater.checkForUpdates()
                
                model.updateButtonTitle = model.upToDateText.randomElement()!
                
                let currentTitle = model.updateButtonTitle
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if model.updateButtonTitle == currentTitle {
                        model.updateButtonTitle = "Check for updates…"
                    }
                }
                //}
            }
        }
        label: {
            Text(model.updateButtonTitle)
                .contentTransition(.numericText())
                .animation(.smooth(duration: 0.25), value: model.updateButtonTitle)
        }
        .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
    }
}

struct UpdateView: View{
    @Environment(\.openURL) private var openURL
    @StateObject private var model = AboutConfigurationModel()
    private let updaterController: SPUStandardUpdaterController
    //@ObservedObject private var updater = AppDelegate.updater
    
    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
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
                        Text("Smoothie")
                            .fontWeight(.medium)
                        
                        Text(
                            "Version \(Bundle.main.appVersion ?? "Unknown") (\(Bundle.main.appBuild ?? 0))"
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
