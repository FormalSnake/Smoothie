//
//  NotchManager.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 11/4/24.
//

import Foundation
import DynamicNotchKit

class NotchManager{
    public func showNotch(systemImage: String, title: String, description: String, showLength: Double){
        let notch = DynamicNotchInfo(
            systemImage: systemImage,
            title: title,
            description: description
        )
        notch.show(for: showLength)
    }
}
