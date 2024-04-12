//
//  ContentView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appDelegate: AppDelegate

    var body: some View {
        VStack {
            Button {
                appDelegate.showPopup("TEST!")
            } label: {
                Text("Show popup")
            }

        }
        .padding()
    }
}
