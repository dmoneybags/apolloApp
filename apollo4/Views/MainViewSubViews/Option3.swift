//
//  Option3.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import SwiftUI

struct Option3: View {
    @Binding var filename: String
    @Binding var title: String
    var body: some View {
        VStack {
            Text(title)
            Divider()
                .padding(.horizontal)
            HStack {
                VStack{
                    Text("Current")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text("97")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 20, height: 30, alignment: .center)
                            .foregroundColor(Color.red)
                    }
                    .frame(width: 100, height: 80, alignment: .center)
                    .padding(.vertical)
                }
                VStack {
                    Text("High")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text("99")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                        VStack{
                            Text("4")
                                .foregroundColor(Color(UIColor.systemGray3))
                            Text("PM")
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                    .frame(width: 100, height: 80, alignment: .center)
                    .padding(.vertical)
                }
                VStack {
                    Text("Low")
                        .foregroundColor(Color(UIColor.systemGray3))
                    HStack {
                        Text("96")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                        VStack{
                            Text("2")
                                .foregroundColor(Color(UIColor.systemGray3))
                            Text("AM")
                                .foregroundColor(Color(UIColor.systemGray3))
                        }
                    }
                    .frame(width: 100, height: 80, alignment: .center)
                    .padding(.vertical)
                }
            }
            .frame(width: 300, height: 180, alignment: .center)
        }
    }
}

struct Option3_Previews: PreviewProvider {
    static var previews: some View {
        Option3(filename: .constant(""), title: .constant("SPO2 Readings"))
    }
}
