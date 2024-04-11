//
//  NotchManager.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 11/4/24.
//

import Foundation
import DynamicNotchKit
import SwiftUI

class NotchManager{
    public func showNotch<Content: View>(content: Content, title: String, description: String, showLength: Double){
        let notch = DynamicNotchInfo(
            iconView: content,
            title: title,
            description: description,
            style: .floating
        )
        notch.show(for: showLength)
    }
}
