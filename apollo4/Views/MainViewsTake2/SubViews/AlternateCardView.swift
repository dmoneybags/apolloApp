//
//  AlternateCardView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/5/22.
//

import SwiftUI

struct AlternateCardView: View {
    var cardData: CardData
    @State var showingCover: Bool = false
    var body: some View {
        VStack{
            HStack{
                Image(systemName: cardData.imageName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(cardData.color)
                    .padding([.trailing, .leading, .top])
                Spacer()
                Text(cardData.name)
                    .fontWeight(.bold)
                    .foregroundColor(cardData.color)
                    .padding(.trailing, 40)
                    .padding(.top)
                Spacer()
            }
            Divider()
            Text(cardData.subLine)
                .font(.footnote)
                .padding(.bottom)
                .foregroundColor(Color(UIColor.systemGray))
                .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.size.width - 60)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.054))
        .cornerRadius(15)
        .fullScreenCover(isPresented: $showingCover){
            if cardData.fullscreenData != nil {
                FullScreenStatView(name: cardData.fullscreenData!.name, statName: cardData.fullscreenData!.statName, tupleData: cardData.fullscreenData!.tupleData, dataRange: cardData.fullscreenData!.dataRange, dataMin: cardData.fullscreenData!.dataMin, gradient: cardData.fullscreenData!.gradient)
            } else {
                if cardData.fullscreenView != nil {
                    cardData.fullscreenView
                }
            }
        }
        .onTapGesture() {
            showingCover = true
        }
    }
}

struct AlternateCardView_Previews: PreviewProvider {
    static var previews: some View {
        AlternateCardView(cardData: CardData(name: "Heart Rate Variability", subLine: "A measure of the standard deviation between heartbeats.", color: .red, imageName: "waveform.path.ecg", fullscreenView: AnyView(EmptyView())))
            .preferredColorScheme(.dark)
    }
}
struct HeartRateCards{
    static var hrVar = CardData(name: "Heart Rate Variability", subLine: "A measure of the standard deviation between heartbeats.", color: .red, imageName: "waveform.path.ecg", fullscreenView: AnyView(UpdatedHrVarView()))
    static var restingHr = CardData(name: "Resting Heart Rate", subLine: "A look into the health of your heart rate while at rest.", color: .blue, imageName: "bed.double", fullscreenView: AnyView(FullScreenStatInfo(tupleData: [getRestingHR(hrData: fetchSpecificStatDataObject(named: "HeartRate").generateTupleData())], topText: "Resting Heart Rate", subText: "Resting heart rate is the hearts rate when not under abnormal stress or exertion", stats: [HeartRate()], colors: [.blue])))
    static var liveRead = CardData(name: "Live Read", subLine: "A mostly debug view for now.", color: .green, imageName: "bolt.heart", fullscreenView: AnyView(LiveReadView()))
    static let list: [CardData] = [hrVar, restingHr, liveRead, CardData.getGoalView(stat: "HeartRate"), CardData.getAlertView(stat: "HeartRate")]
}
struct SPO2Cards{
    static var VO2 = CardData(name: "VO2", subLine: "VO2 is a measure of the health of the lungs, calculated through measurement of your max heart rate.", color: .blue, imageName: "wind", fullscreenView: AnyView(FullScreenStatInfo(readings: [getVO2Max(hrData: fetchSpecificStatDataObject(named: "HeartRate").generateTupleData())], topText: "Current VO2 Max", subText: "A measure to estimate maximum exertion potential", stats: [VO2Max()], colors: [.blue])))
    static let list: [CardData] = [VO2, CardData.getGoalView(stat: "SPO2"), CardData.getAlertView(stat: "SPO2")]
}
struct BPCards{
    static var pulsePressure = CardData(name: "Pulse Pressure", subLine: "A measure of the difference between systolic and diastolic pressure which can indicate the amount of stress on the heart.", color: .green, imageName: "dial.min", fullscreenView: AnyView(FullScreenStatInfo(tupleData: [getPulsePressure(sysData: fetchSpecificStatDataObject(named: "SystolicPressure").generateTupleData(), diaData: fetchSpecificStatDataObject(named: "DiastolicPressure").generateTupleData())], topText: "Pulse Pressure", subText: "A measure of the difference between systolic and diastolic pressure", stats: [PulsePressure()], colors: [.green])))
    static let list: [CardData] = [pulsePressure,
        CardData(name: "Set a goal", subLine: "Set levels for systolic and diastolic pressure which you wish to stay above or below.", color: .orange, imageName: "checkmark.seal", fullscreenView: AnyView(
            AnyView(
                BasicSettingView(title: "Set a Goal"){
                    TabView{
                        GoalView(statInfoObject: SystolicPressure.shared)
                            .tabItem {
                                Label("Systolic Pressure", systemImage: "bolt.fill")
                                    .labelStyle(.titleOnly)
                            }
                        GoalView(statInfoObject: DiastolicPressure.shared)
                            .tabItem {
                                Label("Diastolic Pressure", systemImage: "bolt.fill")
                                    .labelStyle(.titleOnly)
                            }
                    }
                })
        )),
        CardData(name: "Set an Alert", subLine: "Set levels to be alerted at when your resting blood pressure goes above or below a certain level", color: .pink, imageName: "exclamationmark.bubble", fullscreenView: AnyView(
            BasicSettingView(title: "Blood Pressure Notifications"){
                AlertMeView(stats: [SystolicPressure.shared, DiastolicPressure.shared])
                }
        ))
    ]
}

