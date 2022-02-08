//
//  CardView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/15/21.
//

import SwiftUI
//Very sparse template simply takes in a name and color, the content passed in
//makes it very customizable
//also gives the option to either pass statviewdata to initialize a full screen
//stat view by passing the argument of statViewData or initialize allternate view
//by passing the view as anyView
struct CardData {
    var name: String
    var subLine: String
    var color: Color
    var imageName: String
    var fullscreenData: statViewData? = nil
    var fullscreenView: AnyView? = nil
    init(name: String, subLine: String, color: Color, imageName: String, fullscreenData: statViewData){
        self.name = name
        self.subLine = subLine
        self.color = color
        self.imageName = imageName
        self.fullscreenData = fullscreenData
    }
    init(name: String, subLine: String, color: Color, imageName: String, fullscreenView: AnyView){
        self.name = name
        self.subLine = subLine
        self.color = color
        self.imageName = imageName
        self.fullscreenView = fullscreenView
    }
    static func getGoalView(stat: String) -> CardData{
        return CardData(name: "Set a Goal", subLine: "Set a level to be above or below.", color: .orange, imageName: "checkmark.seal", fullscreenView: AnyView(
            BasicSettingView(title: "Set a Goal"){
                GoalView(statInfoObject: getStatInfoObject(named: stat)!)
            }
        ))
    }
    static func getAlertView(stat: String) -> CardData{
        let statInfoObject =  getStatInfoObject(named: stat)!
        return CardData(name: "Set an Alert", subLine: "Set a level to be notified when you go above or below.", color: .pink, imageName: "exclamationmark.bubble", fullscreenView: AnyView(
            BasicSettingView(title: "Set \(statInfoObject.displayName) Notifications"){
                AlertMeView(stats: [statInfoObject])
                }
        ))
    }
}
struct CardView<Content: View>: View {
    var name: String
    //Text color
    var backgroundColor: Color
    //for now until we finish them all
    var fullscreenData: statViewData? = nil
    var fullScreenView: AnyView? = nil
    @State var showingCover: Bool = false
    @ViewBuilder var content: Content
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(backgroundColor)
                    .padding()
                Spacer()
            }
            self.content
        }
        .frame(width: 150, height: 200)
        .preferredColorScheme(.dark)
        .cornerRadius(20)
        .fullScreenCover(isPresented: $showingCover){
            if fullscreenData != nil {
                FullScreenStatView(name: fullscreenData!.name, statName: fullscreenData!.statName, tupleData: fullscreenData!.tupleData, dataRange: fullscreenData!.dataRange, dataMin: fullscreenData!.dataMin, gradient: fullscreenData!.gradient)
            } else {
                if fullScreenView != nil {
                    fullScreenView
                }
            }
        }
        .onTapGesture() {
            showingCover = true
        }
    }
}

