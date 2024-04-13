//
//  Extensions.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-12.
//

import SwiftUI

extension Notification.Name {
    static let nowPlayingChanged = Notification.Name("nowPlayingChanged")
}

extension View {
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(
            center.publisher(for: name, object: object),
            perform: action
        )
    }
}
