//
//  GraphInferenceLegendBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/4/22.
//

import SwiftUI

struct GraphInferenceLegendBox<Content: View>: View {
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    @State private var show: Bool = true
    var title: String
    var subTitle: String
    var numItems: Int
    @ViewBuilder var content: Content
    var body: some View {
        if show{
            VStack{
                HStack{
                    Spacer()
                    Text(title)
                        .padding(.leading, 15)
                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gray)
                        .onTapGesture{
                            show = false
                        }
                }
                .padding([.leading, .top,.trailing])
                Text(subTitle)
                    .foregroundColor(Color(UIColor.systemGray3))
                    .font(.callout)
                Divider()
                Spacer()
                content
                Spacer()
            }
            .frame(width: 180, height: CGFloat(numItems + 1) * 30)
            .background(.black)
            .cornerRadius(20)
            .position(location)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.location = value.location
                    }
            )
            .onAppear{
                location =  CGPoint(x: 180.0 + 70, y: CGFloat(numItems + 1) * 30 + 100)
            }
        }
    }
}
