//
//  BluetoothManager.swift
//  ImagiNet
//
//  Created by Michael Kennedy on 7/24/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Add Bluetooth state change handling here (optional)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Handle Bluetooth state changes if necessary
    }
    
}

extension BluetoothManager {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Filter the desired peripheral based on its name or other properties
        if peripheral.name == "ImagiNetAdding" {
            centralManager.stopScan() // Stop scanning once the desired peripheral is found
            centralManager.connect(peripheral, options: nil)
        }
    }
}


extension BluetoothManager {
    func scanForPeripherals() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
}

extension BluetoothManager {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            // Check if the characteristic properties allow writing
            if characteristic.properties.contains(.writeWithoutResponse) {
                // Send your string data as NSData or Data
                let dataToSend = "YourStringDataToSend".data(using: .utf8)!
                peripheral.writeValue(dataToSend, for: characteristic, type: .withoutResponse)
            }
        }
    }
}



