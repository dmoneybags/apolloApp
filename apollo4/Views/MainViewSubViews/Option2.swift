//
//  Option2.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import SwiftUI

struct Option2: View {
    @Binding var filename: String
    @Binding var title: String
    @State var testData: [Double] = [50, 54, 56, 54, 65, 49, 65, 47, 49, 48, 51, 50, 50, 60, 61, 59]
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .font(.title2)
                    
                Spacer()
            }
            
            Divider()
                .padding(.horizontal)
            HStack {
                VStack {
                    Text("This month")
                        .foregroundColor(Color(UIColor.systemGray3))
                    LineGraph(data: .constant(testData), height: 80, width: 160, heatGradient: true)
                }
                VStack{
                    Text("Current")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text("99")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 20, height: 30, alignment: .center)
                            .foregroundColor(Color.blue)
                    }
                    .frame(width: 120, height: 80, alignment: .center)
                    .padding(.vertical)
                }
            }
            .frame(width: 300, height: 180, alignment: .center)
        }
        //.background(Color.yellow)
    }
}

struct Option2_Previews: PreviewProvider {
    static var previews: some View {
        Option2(filename: .constant(""), title: .constant("SPO2 Readings"))
    }
}
