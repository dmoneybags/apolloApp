//
//  SPO2LevelView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/13/22.
//

import SwiftUI

struct SPO2LevelView: View {
    @Binding var SPO2Data: [Double]
    @State private var showCover: Bool = false
    var body: some View {
        VStack{
            HStack{
                Text("Day's Level")
                    .font(.title2)
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            HStack{
                TickMarkReader(length: 250, width: 20, stat: "SPO2", reading: averageData(data: SPO2Data), color: .purple)
                    .padding()
                    .padding(.leading,40)
                    .frame(width: 140)
                Divider()
                VStack{
                    Text(SPO2().getLabel(reading: averageData(data: SPO2Data)))
                        .font(.title)
                        .padding(.top)
                    Divider()
                    Spacer()
                    Text("\t Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                        .font(.callout)
                        .padding(.bottom, 15)
                        .padding(.horizontal)
                    Divider()
                    Button("Read More..."){
                        showCover = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCover){
            FullScreenStatInfo(readings: [averageData(data: SPO2Data)], topText: "SPO2 Level", subText: "for today", stats: [SPO2()], colors: [.purple])
        }
    }
}

