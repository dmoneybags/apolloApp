//
//  UpdatedHrvarView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/6/22.
//

import SwiftUI
import NotificationBannerSwift
struct UpdatedHrVarView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var statsWrapper: StatDataObjectListWrapper
    //because we don't know how long it will exactly take, we assume 150 seconds
    @ObservedObject var bleManager: BLEManager = .shared
    @ObservedObject var stopWatchManager = StopWatchManager(timeLim: 150)
    @State var liveRead: Bool = true
    @State private var state: LiveReadState = .preread
    @State private var hrVar: Double = 0.0
    private let varPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "HrVar"))
    private let errorNotification = NotificationBanner(title: "Error", subtitle: "Ring not connected", style: .danger)
    var body: some View {
        BasicSettingView(title: "Heart Rate Variability"){
            TabView{
                ZStack{
                    if state == .finished {
                        Color.black.opacity(0.4)
                            .zIndex(1)
                        VStack{
                            HStack{
                                Text("Your heart rate variability:")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .padding([.top, .trailing, .leading], 15)
                                Spacer()
                            }
                            Divider()
                            ZStack{
                                RingChart(progress: .constant(70/130), text: .constant(""), color: .blue)
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .zIndex(2)
                                    .padding()
                                Text(String(hrVar) + "ms")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            Divider()
                            Button(action: reset){
                                Text("Ok")
                                    .font(.title2)
                            }
                            .padding()
                        }
                        .frame(width: 250, height: 350, alignment: .center)
                        .background(Color.black)
                        .zIndex(3)
                        .cornerRadius(20)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.8)))
                    }
                    VStack{
                        Spacer()
                        ZStack{
                            RingChart(progress: .constant(stopWatchManager.progress), text: .constant(""), color: Color.pink)
                                .padding()
                            ECGAnimation()
                                .padding(.all, 60)
                        }
                        .frame(height: 300)
                        Spacer()
                        if (state ==  .preread || state == .finished){
                            Button(action: startHrVar){
                                Text("Start")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding()
                        } else {
                            //Notification when done
                            Text("Readings usually take about 3 minutes. You can use other apps during the reading or put your phone in sleep mode, and then return.")
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(LinearGradient(colors: [.clear, .pink], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 2)))
                    .onReceive(varPub){object in
                        hrVar = (object.object as! NSString).doubleValue
                        state = .finished
                    }
                }
                .tabItem {
                    Label("Live Read", systemImage: "waveform.path.ecg")
                }
                FullScreenStatView(name: "Heart Rate Variability", tupleData: fetchSpecificStatDataObject(named: "HrVar").generateTupleData(), dataRange: 200, dataMin: 0, gradient: Gradient(colors: [.purple, .pink]), showTitle: false)
                    .tabItem {
                        Label("Data", systemImage: "heart.text.square.fill")
                    }
            }
        }
        .edgesIgnoringSafeArea([.bottom])
    }
    func startHrVar(){
        if bleManager.connectedPeripheral != nil {
            print("Changing to raw mode; sending requests")
            let on = withUnsafeBytes(of: 0x02) { Data($0) }
            bleManager.connectedPeripheral!._CBPeripheral.writeValue(on, for: (bleManager.connectedPeripheral!.characteristics["isRaw"])!, type: .withoutResponse)
            print("Sent Requests")
            state = .reading
            stopWatchManager.start()
        } else {
            errorNotification.show()
        }
    }
    func reset(){
        hrVar = 0.0
        state = .preread
    }
}
