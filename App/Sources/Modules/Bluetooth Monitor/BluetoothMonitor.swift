//
//  BluetoothMonitor.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 13/4/24.
//

import Foundation
import SwiftUI
import IOBluetooth

// HALF WORKING.. TO BE IMPLEMENTED
class BluetoothMonitor: NSObject, MonitorProtocol {
    private var connectionNotification: IOBluetoothUserNotification?
    private var disconnectionNotification: IOBluetoothUserNotification?

    private var previousDevices: [IOBluetoothDevice] = []

    private var currentDevices: [IOBluetoothDevice] {
        let result = IOBluetoothDevice.pairedDevices()
            .compactMap { $0 as? IOBluetoothDevice }

        for item in result {
            item.register(
                forDisconnectNotification: self,
                selector: #selector(disconnectionNotificationReceived(_:))
            )
        }

        return result
    }

    func addObservers() {
        updatePrevious()

        // Can't find a way to get notified about discornnections yet
        connectionNotification = IOBluetoothDevice.register(
            forConnectNotifications: self,
            selector: #selector(connectionNotificationReceived(_:))
        )
    }

    func updateData() {
        // Implement if needed
    }

    func show() {
        // Show shit
    }

    @objc private func connectionNotificationReceived(_ sender: Any) {
//        let previous = previousDevices
//        let current = currentDevices
//
//        let connected = current.filter { !previous.contains($0) }
//        print(connected)
//
//        updatePrevious()
    }

    @objc private func disconnectionNotificationReceived(_ sender: Any) {
//        let previous = previousDevices
//        let current = currentDevices
//
//        let disconnected = previous.filter { !current.contains($0) }
//        print(disconnected)
//
//        updatePrevious()
    }

    func updatePrevious() {
        previousDevices = currentDevices.filter({ $0.isConnected() })
    }
}
