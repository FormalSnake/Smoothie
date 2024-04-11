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
                NotchManager().showNotch(content: ContentView(), title: "Trigger notch", description: "Notchception??", showLength: 2)
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
