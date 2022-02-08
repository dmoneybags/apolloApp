//
//  HeartRateSegmentedChartView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/6/22.
//

import SwiftUI

struct HeartRateSegmentedChartView: View {
    var stat: Stat
    var tuples: [(Double,  Date)]
    var body: some View {
        VStack{
            HStack{
                Text("Day's Levels")
                    .font(.title2)
                    .padding(.top)
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(.horizontal)
                Spacer()
            }
            Divider()
            Spacer()
            SegmentedRingChartView(stat: stat, dataList: tuples)
                .frame(width: 178)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.size.width - 20, height: 330, alignment: .center)
    }
}
