//
//  ContentView.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button( action: {
                NotchManager().showNotch(systemImage: "figure", title: "Figure", description: "Looks like a person", showLength: 2)
            }, label: {
                Text("Trigger the Notch!")
            }
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
