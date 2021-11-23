//
//  UUID Structs.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/6/21.
//

import Foundation
import CoreBluetooth

struct CBUUIDs {
    static let deviceUUID = CBUUID(string: "38792B84-AD50-388A-EE4D-376DFF86F8B9")
    static let sensorUUID = CBUUID(string: "F3D5488C-DA6B-BD8C-B54C-961963B399B8")
    static let characteristicsDict = [CBUUID(string: "575d4d03-67c5-41ea-8cb4-c97864341973"): "SerialNumber",
                                  CBUUID(string: "0ad7fa8d-52b9-4e25-9bcf-505d94c20881"): "DataTransmissionFrequencyMode",
                                  CBUUID(string: "2778DD46-89C2-B882-6E48-8B160275B8E3"): "SystolicPressure",
                                  CBUUID(string: "34341FDE-36AC-F6AA-DF4C-E29A727DA7EF"): "DiastolicPressure",
                                  CBUUID(string: "E7568C31-FE31-A29B-A444-47E300C2D962"): "HeartRate",
                                  CBUUID(string: "DECF365D-17A6-43A7-ED47-BE1634730BA2"): "SPO2"
    ]
}
