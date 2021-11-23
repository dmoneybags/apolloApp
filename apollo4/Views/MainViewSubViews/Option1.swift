//
//  Option1.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import SwiftUI

struct Option1: View {
    @Binding var filename: String
    @Binding var title: String
    var body: some View {
        VStack {
            Text(title)
            Divider()
                .padding(.horizontal)
            HStack {
                VStack {
                    Text("Today")
                        .foregroundColor(Color(UIColor.systemGray3))
                    RingChart(progress: .constant(0.4), text: .constant("69"))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
                VStack {
                    Text("This month")
                        .foregroundColor(Color(UIColor.systemGray3))
                        .multilineTextAlignment(.center)
                    RingChart(progress: .constant(0.7), text: .constant("90"))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
                VStack {
                    Text("This year")
                        .foregroundColor(Color(UIColor.systemGray3))
                    RingChart(progress: .constant(0.2), text: .constant("70"))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .frame(width: 100, height: 120, alignment: .center)
            }
            .frame(width: 300, height: 120, alignment: .center)
        }
        //.background(Color.green)
    }
}

struct Option1_Previews: PreviewProvider {
    static var previews: some View {
        Option1(filename: .constant(""), title: .constant("BPM Averages"))
    }
}
