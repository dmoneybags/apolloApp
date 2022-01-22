//
//  MainUIBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//

import SwiftUI

struct MainUIBox<Content: View, Content2: View>: View {
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
    @State private var showingData: Bool = false
    @State private var showInfo: Bool = false
    //Pass in content to show in scrollview, passed with a bracket
    //Same way you would add content to a VStack
    @ViewBuilder var cardContent: Content
    @ViewBuilder var content: Content2
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
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
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .aspectRatio(1.0, contentMode: .fit)
                    .foregroundColor(foregroundColor ?? Color.white)
                    .padding(.top)
                    .padding(.horizontal)
                    .scaleEffect(imageName == "heart.fill" ? animatorVal : 1.0)
                    .onAppear(){
                        print("MainUIbox loaded for \(title)")
                        withAnimation(Animation.easeInOut(duration: 60.0/dataVal).repeatForever()){
                            animatorVal = 1.0
                        }
                    }
                Text(dataValStr)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.trailing)
            }
            Divider()
                .padding(.horizontal)
                .padding(.top,  -10)
            //ScrollView for main views
            MainUIBoxScroller(numViews: numScrollViews, width: UIScreen.main.bounds.size.width - 20){
                //content we passed in using brackets
                content
            }
            HStack {
                //Opens full screen graph view
                Button("See more data..."){
                    showingData.toggle()
                }
                .padding(.horizontal)
                Spacer()
            }
            Divider()
            ScrollView(.horizontal){
                HStack{
                    cardContent
                }
            }
            .frame(width: UIScreen.main.bounds.size.width - 60, height: 250, alignment: .center)
        }
        //Code for full screen graph
        .fullScreenCover(isPresented: $showingData){
            if fullscreenData.multiTupleData == nil {
                FullScreenStatView(name: fullscreenData.name, statName: fullscreenData.statName, tupleData: fullscreenData.tupleData, dataRange: fullscreenData.dataRange, dataMin: fullscreenData.dataMin, gradient: fullscreenData.gradient)
                    .environmentObject(statsWrapper)
            } else {
                MultilineFullScreenStatView(name: fullscreenData.name, multiTupleData: fullscreenData.multiTupleData!)
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(15.0)
        .padding(.leading, 10.0)
    }
    private func pass(){
        print("")
    }
}


