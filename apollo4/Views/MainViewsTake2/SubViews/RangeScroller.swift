//
//  RangeScroller.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/13/22.
//

import SwiftUI

struct RangeScroller: View {
    var stat: Stat
    var body: some View {
        VStack{
            Text(stat.displayName + " Ranges")
                .fontWeight(.bold)
                .foregroundColor(stat.mainColor)
            Divider()
            MainUIBoxScroller(numViews: stat.labels.count, width: UIScreen.main.bounds.width){
                ForEach(stat.labels.indices, id: \.self){indice in
                    let label = stat.labels[indice]
                    HStack{
                        VStack{
                            Text(label)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(stat.getColor(forLabel: label))
                            Divider()
                                .padding(.horizontal, 30)
                            HStack{
                                Text(String(stat.getRange(label: label).0))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(stat.getColor(forLabel: label))
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(stat.getColor(forLabel: label))
                                Text(String(stat.getRange(label: label).1))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(stat.getColor(forLabel: label))
                            }
                        }
                        CapsuleReader(reading: stat.getRange(label: label).1, height: 200, stat: stat.name)
                            .padding(.horizontal)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
            }
        }
    }
}
