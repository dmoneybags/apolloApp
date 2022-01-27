//
//  AppearanceSettings.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/25/22.
//
import Foundation
import SwiftUI
import UIKit

extension Color: RawRepresentable {

    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
        
    }

    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }

}
struct AppearanceSettings: View {
    @AppStorage("APPEARANCE:MAINBACKGROUND") var bgColor: Color = .purple
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Color Settings")){
                    ColorPicker("Main Screen Background", selection: $bgColor)
                }
            }
        }
    }
}

struct AppearanceSettings_Previews: PreviewProvider {
    static var previews: some View {
        BasicSettingView(title: "Change App Appearance"){
            AppearanceSettings().preferredColorScheme(.dark)
        }
    }
}
