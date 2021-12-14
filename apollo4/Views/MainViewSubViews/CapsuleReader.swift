//
//  CapsuleReader.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/24/21.
//

import SwiftUI

struct CapsuleReader: View {
    @State var reading: Double
    @State var height: Double
    @State private var loaded: Bool = false
    var stat: String
    let titles = ["Low", "Medium", "High"]
    var body: some View {
        let (min, _) = getMinMaxVals(stat: stat)
        let progressVal = getProgress(stat: stat, reading: reading)
        VStack {
            ZStack {
                Capsule()
                    .frame(width: 10, height: height, alignment: .center)
                    .foregroundColor(Color(UIColor.systemGray3))
                Capsule()
                    .frame(width: 10, height: loaded ? progressVal * height : 0, alignment: .center)
                    .foregroundColor(getColor(stat: stat, progress: progressVal))
                    .padding(.top, height - ((reading - min)/(getStatRange(stat: stat)) * height))
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
        let indicator = getProgress(stat: stat, reading: reading)
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
        CapsuleReader(reading: 5, height: 300, stat: "")
    }
}
