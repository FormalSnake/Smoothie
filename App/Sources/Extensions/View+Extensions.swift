//
//  View+Extensions.swift
//  Smoothie
//
//  Created by Kai Azim on 2024-04-16.
//

import SwiftUI

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
