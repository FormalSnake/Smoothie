//
//  BluetoothMonitor.swift
//  Smoothie
//
//  Created by Kyan De Sutter on 13/4/24.
//

import Foundation
import SwiftUI
import IOBluetooth

class BluetoothMonitor: NSObject, MonitorProtocol {
    var deviceSelector: IOBluetoothDeviceInquiry!
    
    func addObservers() {
        deviceSelector = IOBluetoothDeviceInquiry(delegate: self)
        deviceSelector?.start()
    }
    
    func updateData() {
        // Implement if needed
    }
    
    func show() {
        // Show shit
    }
}

extension BluetoothMonitor: IOBluetoothDeviceInquiryDelegate {
    func deviceInquiryStarted(_ sender: IOBluetoothDeviceInquiry!) {
        print("Bluetooth device inquiry started")
    }
    
    func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        print("Device found: \(device.name ?? "Unknown device")")
    }
    
    func deviceInquiryComplete(_ sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
        print("Bluetooth device inquiry completed")
        if !aborted {
            // Restart the inquiry
            sender.start()
        }
    }
}
