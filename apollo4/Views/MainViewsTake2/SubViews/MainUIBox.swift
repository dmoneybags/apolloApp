//
//  MainUIBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//

import SwiftUI

struct MainUIBox<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    //Value which will be changed within a withAnimation framework to animate the heart (if heartRate)
    @State private var animatorVal : Double = 0.7
    //Stats passed in for inference
    //Most
    @EnvironmentObject var statsWrapper: StatDataObjectListWrapper
    //String at top of box
    var title: String
    //Current value
    var dataVal: Double
    //Separated as to be able to give rules for formatting
    var dataValStr: String
    //The small image in the top corner
    var imageName: String
    //Color of image
    var foregroundColor: Color?
    var numScrollViews: Int
    //Passed in for fullscreen statview cover
    var stats: [Stat]
    var fullscreenData: statViewData
    var cardData: [CardData]
    @State private var showingData: Bool = false
    @State private var showInfo: Bool = false
    @State private var showMore: Bool = false
    //Pass in content to show in scrollview, passed with a bracket
    //Same way you would add content to a VStack
    @ViewBuilder var content: Content
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
                    .font(.system(size: 500))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(.bottom, 5)
                    .offset(x: -10, y: 0.0)
                    .foregroundColor(Color(UIColor.systemGray))
                    .onTapGesture {
                        showInfo = true
                    }
                    .fullScreenCover(isPresented: $showInfo){
                        WhatIsStatName(stats: stats)
                    }
                Spacer()
                CurrentBtnView(dataValStr: dataValStr, currentView:
                                fullscreenData.statName != nil ?
                               AnyView(CurrentStatView(stat: fullscreenData.statName ?? "Blood Pressure", gradient: fullscreenData.gradient)):
                                AnyView(CurrentBPView())
                )
            }
            Divider()
                .padding(.horizontal)
                .padding(.top,  -10)
            //ScrollView for main views
            MainUIBoxScroller(numViews: numScrollViews, width: UIScreen.main.bounds.size.width - 20){
                //content we passed in using brackets
                content
            }
            if fullscreenData.tupleData.count > 2 || fullscreenData.multiTupleData?[0].count ?? 0 > 2{
                HStack {
                    //Opens full screen graph view
                    Button("See more data..."){
                        showingData.toggle()
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
            Divider()
            Button{
                withAnimation{
                    showMore.toggle()
                }
            } label: {
                HStack{
                    Text("More")
                    Spacer()
                    Image(systemName: "chevron.backward")
                        .rotationEffect(Angle(degrees: showMore ? 270.0 : 180.0))
                }
                .frame(width: UIScreen.main.bounds.width - 50)
            }
            .padding(.bottom)
            if showMore {
                Divider()
                ScrollView{
                    VStack(spacing: 10.0){
                        ForEach(cardData.indices, id: \.self){indice in
                            AlternateCardView(cardData: cardData[indice])
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        //Code for full screen graph
        .fullScreenCover(isPresented: $showingData){
            if fullscreenData.multiTupleData == nil {
                FullScreenStatView(name: fullscreenData.name, statName: fullscreenData.statName, tupleData: fullscreenData.tupleData, dataRange: fullscreenData.dataRange, dataMin: fullscreenData.dataMin, gradient: fullscreenData.gradient)
                    .background(LinearGradient(colors: [stats[0].mainColor.opacity(0.4), .clear], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
            } else {
                MultilineFullScreenStatView(name: fullscreenData.name, multiTupleData: fullscreenData.multiTupleData!)
                    .background(LinearGradient(colors: [.blue.opacity(0.4), .clear], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(15.0)
    }
    private func pass(){
        print("")
    }
}


