//
//  HrVarView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/4/22.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct HrVarView: View {
    @EnvironmentObject var bleManager: BLEManager
    @Environment(\.presentationMode) var presentationMode
    //because we don't know how long it will exactly take, we assume 150 seconds
    @ObservedObject var stopWatchManager = StopWatchManager(timeLim: 150)
    @State var liveRead: Bool = true
    @State private var state: LiveReadState = .preread
    @State private var hrVar: Double = 0.0
    let varPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "HrVar"))
    var body: some View {
        ZStack{
            if state == .finished {
                VStack{
                    HStack{
                        Text("Your heart rate variance:")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding([.top, .trailing, .leading], 15)
                        Spacer()
                    }
                    Divider()
                    ZStack{
                        RingChart(progress: .constant(70/130), text: .constant(""), color: .blue)
                            .frame(width: 150, height: 150, alignment: .center)
                            .zIndex(2)
                        Text(String(hrVar) + "ms")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button(action: reset){
                        Text("Ok")
                            .font(.title2)
                    }
                    .padding()
                    .buttonStyle(.bordered)
                }
                .frame(width: 250, height: 300, alignment: .center)
                .background(Color.white)
                .zIndex(3)
                .cornerRadius(20)
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.8)))
            }
            VStack{
                HStack {
                    Text("Heart Rate Variance")
                        .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    Spacer()
                }
                Divider()
                    .padding(.horizontal)
                Text("Heart Rate Variance is a measure of the average differences between heart beats. A high heart rate variabilty indicates that the nervous system is adequately maintaining the heart rate.")
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                HStack{
                    Spacer()
                    Text("Live Read")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 150)
                        .background(Color.green.opacity(liveRead ? 0.7 : 0.0))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(){
                                liveRead = true
                            }
                        }
                    Spacer()
                    Text("Data")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 150)
                        .background(Color.green.opacity(liveRead ? 0.0 : 0.7))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(){
                                liveRead = false
                            }
                        }
                    Spacer()
                }
                Divider()
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
                    }
                    .padding()
                    .buttonStyle(.bordered)
                    Button("Exit", role: .destructive){
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                } else {
                    //Notification when done
                    Text("Readings usually take about 3 minutes. You can use other apps during the reading or put your phone in sleep mode, and then return.")
                }
                Spacer()
            }
            .onReceive(varPub){object in
                hrVar = (object.object as! NSString).doubleValue
                state = .finished
            }
        }
    }
    func startHrVar(){
        print("Changing to raw mode; sending requests")
        let on = withUnsafeBytes(of: 0x02) { Data($0) }
        bleManager.connectedPeripheral?._CBPeripheral.writeValue(on, for: (bleManager.connectedPeripheral!.characteristics["isRaw"])!, type: .withoutResponse)
        print("Sent Requests")
        state = .reading
        stopWatchManager.start()
    }
    func reset(){
        hrVar = 0.0
        state = .preread
    }
}

struct HrVarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            HrVarView().preferredColorScheme(.dark)
        }
    }
}
