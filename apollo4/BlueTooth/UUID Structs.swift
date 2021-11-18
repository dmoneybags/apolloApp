//
//  UUID Structs.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/6/21.
//

import Foundation
import CoreBluetooth

struct CBUUIDs {
    static let deviceUUID = CBUUID(string: "0x591afb07ae374a0fb295180550e26178")
    static let sensorUUID = CBUUID(string: "0x8537045a364d461e9109e6031f5ab075")
    static let characteristicsDict = [CBUUID(string: "0x20ceb34c0349427b9e9ae2e63f728d76"): "SerialNumber",
                                  CBUUID(string: "0x118ae3fd894d4bde9e5ad9fae68a10b5"): "DataTransmissionFrequencyMode",
                                  CBUUID(string: "0xdf5dd0937ea045028c62115f4ef824c1"): "SystolicPressure",
                                  CBUUID(string: "0x6c011de3e781463dad42f4ca06da82e9"): "DiastolicPressure",
                                  CBUUID(string: "0x7e96b8d293994e798ceaf0f8a8a7ca9c"): "HeartRate",
                                  CBUUID(string: "0x0988710aae9045298a9be6dc6f008c86"): "SPO2"
    ]
}
