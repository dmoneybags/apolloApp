//
//  WhatIsStatName.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/13/22.
//

import SwiftUI

struct WhatIsStatName: View {
    @Environment(\.presentationMode) var presentationMode
    //Pretty much only argument we need, Statinfo object holds all the data
    //Multiple stats is only for blood pressure and absolutely nothing else
    var stat: [Stat]
    init(stat: Stat){
        self.stat = [stat]
    }
    init(stats: [Stat]){
        self.stat = stats
        assert(stats.count < 3)
    }
    var body: some View {
        VStack{
            ScrollView{
                StickyHeader{
                    Image(stat[0].imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                HStack{
                    Text(stat[0].infoTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                }
                Divider()
                    .padding(.horizontal, 30)
                HStack{
                    Text("Overview")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(stat[0].mainColor)
                        .padding(.horizontal)
                    Spacer()
                }
                Text("\t Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.horizontal)
                HStack{
                    Text("Importance")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(stat[0].mainColor)
                        .padding(.horizontal)
                    Spacer()
                }
                Text("\t Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding([.bottom, .trailing, .leading], 15)
                ForEach(stat.indices, id: \.self){indice in
                    RangeScroller(stat: stat[indice])
                }
            }
            Spacer()
            Button("Exit", role: .destructive){
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

