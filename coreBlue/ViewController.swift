//
//  ViewController.swift
//  coreBlue
//
//  Created by Efe Mazlumoğlu on 2.05.2021.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    var manager: CBCentralManager!
    var remotePeripheral: [CBPeripheral] = []
    var device: CBPeripheral?
    var characteristics: [CBCharacteristic]?
    var serviceUUID = "1234"
    var char1 = "FFE1"
    let deviceName = "Efe Maz's Macbook Pro"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: .main)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapped(_ sender: Any) {
        //
    }
    

}

extension ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Checking")
        switch(central.state) {
        case.unsupported:
            button.setTitle("BLE is not supported", for: .normal)
            print("BLE is not supported")
        case.unauthorized:
            button.setTitle("BLE is not authorized", for: .normal)
            print("BLE is unauthorized")
        case.unknown:
            button.setTitle("BLE is unknown", for: .normal)
            print("BLE is Unknown")
        case.resetting:
            button.setTitle("BLE is resetting", for: .normal)
            print("BLE is Resetting")
        case.poweredOff:
            button.setTitle("BLE is powerred off", for: .normal)
            print("BLE service is powered off")
        case.poweredOn:
            button.setTitle("BLE is powered on and start scanning", for: .normal)
            print("BLE service is powered on")
            print("Start Scanning")
            manager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("default state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral: \(peripheral)")
        peripheral.delegate = self
        self.remotePeripheral.append(peripheral)
        manager.connect(peripheral, options: nil)
        manager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected to \(peripheral) right now")
        button.setTitle("Connected to \(peripheral)", for: .normal)
    }
    
}

extension ViewController: CBPeripheralDelegate {
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("updated peripheral: ", peripheral)
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("ready peripheral: ", peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("service updated peripheral: ", peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        device = peripheral
        characteristics = service.characteristics
        print("characteristics: ", service.characteristics as Any)
        var value: UInt8 = 1
        let data = NSData(bytes: &value, length: MemoryLayout<UInt8>.size)
        for characteristic in (service.characteristics)! {
            if (characteristic.uuid.uuidString == "FFE1") {
                print("device to write: ", data)
                device?.writeValue(data as Data, for: characteristic,type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
}


