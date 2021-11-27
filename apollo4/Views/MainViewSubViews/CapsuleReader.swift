//
//  CapsuleReader.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/24/21.
//

import SwiftUI

struct CapsuleReader: View {
    @State var range: Double
    @State var min: Double
    @State var reading: Double
    @State var height: Double
    @State var loaded: Bool = false
    let titles = ["Low", "Medium", "High"]
    var body: some View {
        VStack {
            ZStack {
                Capsule()
                    .frame(width: 10, height: height, alignment: .center)
                    .foregroundColor(Color(UIColor.systemGray3))
                Capsule()
                    .frame(width: 10, height: loaded ? (reading - min)/(range) * height : 0, alignment: .center)
                    .foregroundColor(Color.blue)
                    .padding(.top, height - ((reading - min)/(range) * height))
                    .onAppear(){
                        withAnimation(){
                            loaded = true
                        }
                    }
            }
            .frame(width: 100, height: height, alignment: .center)
            Text(titles[getTitleIndex()])
                .foregroundColor(Color(UIColor.systemGray))
        }
    }
    func getTitleIndex() -> Int{
        let indicator = (reading - min)/(range)
        switch indicator {
            case 0..<0.3:
                return 0
            case 0.3..<0.6:
                return 1
            case 0.6..<0.9:
                return 2
            default:
                return 2
        }
    }
}

struct CapsuleReader_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleReader(range: 7, min: 2, reading: 5, height: 300)
    }
}
