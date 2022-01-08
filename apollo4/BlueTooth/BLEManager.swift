//
//  BLEManager.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/5/21.
//

import Foundation
import CoreBluetooth
import SwiftUI

struct Peripheral: Identifiable {
    let _CBPeripheral : CBPeripheral
    let id: Int
    let name: String
    let rssi: Int
    public var characteristics: [String: CBCharacteristic] = [:]
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    var myCentral: CBCentralManager!
    var _ID: CBUUID?
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var connectedPeripheral: Peripheral?
    //@Published var managerCharacteristics: [String: CBCharacteristic] = [:]
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    func startScanning() -> Int {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: [CBUUIDs.deviceUUID], options: nil)
        if self.connectedPeripheral == nil {
            return 1
        } else {
            return 0
            }
        }
    func stopScanning() {
            print("stopScanning")
            myCentral.stopScan()
        }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let peripheralName: String?
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                    peripheralName = name
                }
                else {
                    peripheralName = "Unknown"
                }
        let newPeripheral = Peripheral(_CBPeripheral: peripheral, id:peripherals.count, name: peripheralName!, rssi: RSSI.intValue)
        //if connectedPeripheral == nil && peripheral.name == "Feather nRF52832"{
        myCentral.connect(newPeripheral._CBPeripheral, options: nil)
        connectedPeripheral = newPeripheral
        connectedPeripheral!._CBPeripheral.delegate = self
        print("connected to \(peripheralName)")
        //}
        print("Peripheral Discovered: \(peripheral)")
        print("Peripheral name: \(peripheral.name)")
        print ("Advertisement Data : \(advertisementData)")
        
        print(newPeripheral)
        peripherals.append(newPeripheral)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            stopScanning()
        connectedPeripheral!._CBPeripheral.discoverServices(nil)
          }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    func createConnection(peripheral: Peripheral) {
        myCentral.connect(peripheral._CBPeripheral)
        self.connectedPeripheral = peripheral
        self.connectedPeripheral?._CBPeripheral.delegate = self
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

          guard let characteristics = service.characteristics else {
              return
          }

        print("Found \(characteristics.count) characteristics for service \(service.description)")
        for characteristic in characteristics {
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
            if peripheral == connectedPeripheral?._CBPeripheral && CBUUIDs.characteristicsDict[characteristic.uuid] != nil{
                let characteristicName = CBUUIDs.characteristicsDict[characteristic.uuid]!
                connectedPeripheral?.characteristics[characteristicName] = characteristic
                print("added \(characteristicName) to peripherals dictionary")
            }
            print(characteristic.uuid)
            if CBUUIDs.characteristicsDict[characteristic.uuid] != nil {
                print("Set up characteristic: \(CBUUIDs.characteristicsDict[characteristic.uuid]!)")
                }
            }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            print("*******************************************************")

            if ((error) != nil) {
                print("Error discovering services: \(error!.localizedDescription)")
                return
            }
            guard let services = peripheral.services else {
                return
            }
            print(services)
            //We need to discover the all characteristic
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            print("Discovered Services: \(services)")
        }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
            print("*******************************************************")
          print("Function: \(#function),Line: \(#line)")
            if (error != nil) {
                print("Error changing notification state for \(characteristic.uuid):\(String(describing: error?.localizedDescription))")

            } else {
                print("Characteristic's value subscribed")
            }

            if (characteristic.isNotifying) {
                print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
            }
        }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("got error updating: \(error)")
        }
          var characteristicASCIIValue = NSString()

          guard let characteristicValue = characteristic.value
                else {
                    print("found nil for \(characteristic)")
                    return
                }
        print(characteristicValue)
        
        guard let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue)
            else {
            print("ascii failed for \(characteristic)")
                return
        }
        
        characteristicASCIIValue = ASCIIstring
          print("Value Recieved: \((characteristicASCIIValue as String)) for characteristic: \(characteristic)")
        
        if CBUUIDs.characteristicsDict[characteristic.uuid] != nil {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: CBUUIDs.characteristicsDict[characteristic.uuid]!), object: "\((characteristicASCIIValue as String))")
            if CBUUIDs.characteristicsDict[characteristic.uuid] != "isRaw" && CBUUIDs.characteristicsDict[characteristic.uuid] != "Raw"{
                updateStatDataObject(withString: ASCIIstring as String, statNamed: CBUUIDs.characteristicsDict[characteristic.uuid]!)
            }
        }
    }
}
