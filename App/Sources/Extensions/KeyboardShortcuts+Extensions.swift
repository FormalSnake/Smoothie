//
//  KeyboardShortcuts+Extensions.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let triggerMediaPlayer = Self("triggerMediaPlayer", default: .init(.space, modifiers: [.command, .shift]))
    static let triggerAudioOutput = Self("triggerAudioOutput", default: .init(.a, modifiers: [.command, .shift]))
    static let triggerBattery = Self("triggerBattery", default: .init(.b, modifiers: [.command, .shift]))
}
