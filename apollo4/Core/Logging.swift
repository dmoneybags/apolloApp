//
//  Logging.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import Foundation
func shouldWrite() -> Bool {
    let date = Date()
    let calendar = Calendar.current
    let second = calendar.component(.second, from: date)
    if second % 10 == 0 {
        return true
    }
    return false
}
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
func writeToCsv(filename: URL, data: String){
    if data == "0"{
        print("Found 0, write failed")
        return
    }
    print("writing to \(filename)")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    let dataDate: String = dateFormatter.string(from: Date())
    let str: String = dataDate + "," + data + "\n"
    do {
        if FileManager.default.fileExists(atPath: filename.path) {
            let fileHandle = try FileHandle(forWritingTo: filename)
            fileHandle.seekToEndOfFile()
            fileHandle.write(str.data(using: String.Encoding.utf8)!)
            print(str)
            fileHandle.closeFile()
        } else {
            print(str)
            try! str.data(using: String.Encoding.utf8)!.write(to: filename)
        }
    } catch {
        print(error)
    }
}
