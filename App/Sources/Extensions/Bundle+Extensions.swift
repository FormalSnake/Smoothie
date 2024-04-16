//
//  Bundle+Extensions.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 16/4/24.
//

import Foundation


extension Bundle {
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}
