//
//  MainUIBoxScroller.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//

import SwiftUI

struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct MainUIBoxScroller<Content: View>: View {
    var numViews: Int
    var width: CGFloat
    //Content passed from MainUIBox
    @ViewBuilder var content: Content
    //Which one are we on?
    @State private var selector = 0
    @State private var offsetX: CGFloat = 0
    var body: some View {
        VStack{
            HStack{
                ForEach(0..<numViews, id: \.self){index in
                    Circle()
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(selector == index ? Color.blue : Color(UIColor.systemGray3))
                }
            }
            ScrollViewReader { scroller in
                ScrollView(.horizontal){
                    HStack{
                        //Hidden view used to initialize a geometry reader without needing to have
                        //it wrap over the whole view
                        Text("")
                        //best solution we could get was to just cancel out width with neegative padding
                            .frame(width: 10)
                            .padding(.trailing, -10)
                            .background(
                                GeometryReader { proxy in
                                    Color.red
                                        .preference(
                                            key: OffsetPreferenceKey.self,
                                            value: proxy.frame(in: .named("scroll")).minX
                                        )
                                })
                        content
                    }
                }
                .frame(width: width, alignment: .center)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(OffsetPreferenceKey.self) { value in
                    if abs(value - offsetX) >= 170{
                        offsetX = value
                    }
                    print(offsetX)
                }
                .onChange(of: offsetX) { _ in
                    print("Scrolling to \(getView())")
                    withAnimation(){
                        scroller.scrollTo(getView(), anchor: .center)
                    }
                }
                
            }
        }
        .frame(width: width)
    }
    //HardCoded for now, will be changed to use a proportion of width in the future
    private func getView() -> Int {
        let viewNum = abs(Int((offsetX - width/2)/width))
        selector = viewNum
        return viewNum
    }
}

