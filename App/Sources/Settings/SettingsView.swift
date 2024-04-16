//
//  SettingsView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import SwiftUI
import Defaults

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
