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
            Text("This window is useless :3")
        }
        .padding()
    }
}
