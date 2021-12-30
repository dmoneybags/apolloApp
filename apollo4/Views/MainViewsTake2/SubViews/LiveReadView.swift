//
//  LiveReadView.swift
//  apollo4
//
//
//  Created by Daniel DeMoney on 12/29/21.
//

import SwiftUI

enum LiveReadState {
    case preread
    case reading
    case finished
}

struct LiveReadView: View {
    @EnvironmentObject var bleManager: BLEManager
    @ObservedObject var stopWatchManager = StopWatchManager()
    @State var data: [Double] = [85000, 85000]
    @State private var readingAnimator = 0.2
    @State private var state: LiveReadState = .preread
    let rawPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "Raw"))
    var body: some View {
        let fakeData = genFakeData()
        VStack{
            Text("Check your waveform")
                .font(.title)
            Divider()
                .padding(.horizontal)
            if state == .finished {
                Text("In the future a popup will come up with data")
            } else {
                Text("Debug View for now")
            }
            LineGraph(data: state == .preread ? .constant(fakeData) : $data, dataTime: .constant(nil), height: 400, width: UIScreen.main.bounds.width, gradient: Gradient(colors: [Color.purple, Color.orange]))
                .allowsHitTesting(false)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 4)
                    )
            if state == .preread {
                Button(action: startRaw){
                    Text("Start")
                        .font(.title2)
                        .padding()
                }
                Divider()
                    .padding(.horizontal, 100)
            } else if state == .reading {
                HStack{
                    Text(String(format: "%0.1f", stopWatchManager.secondsElapsed))
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Text("Reading")
                        .font(.title2)
                        .padding()
                        .opacity(readingAnimator)
                        .onAppear(){
                            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()){
                                readingAnimator = 1.0
                            }
                        }
                }
            }
            //State == .finished
            else {
                
            }
        }
        .onReceive(rawPub){output in
            let reading = (output as? NSString)!.doubleValue
            print("Got reading of \(reading)")
            genHeartBeatList(reading: reading)
        }
        .onChange(of: stopWatchManager.secondsElapsed){seconds in
            if seconds > 10 {
                state == .finished
            }
        }
    }
    public func startRaw(){
        print("Changing to raw mode; sending requests")
        bleManager.connectedPeripheral?._CBPeripheral.writeValue(withUnsafeBytes(of: 1) { Data($0) }, for: (bleManager.connectedPeripheral?.characteristics["isRaw"])!, type: .withoutResponse)
        print("Sent Requests")
        state = .reading
        stopWatchManager.start()
    }
    private func genFakeData() -> [Double]{
        var fakeData : [Double] = []
        for i in 0..<100{
            fakeData.append(sin(Double(i)/5) * 150 + 150)
        }
        return fakeData
    }
    func genHeartBeatList(reading: Double){
           if reading != 0.0 {
               if self.data.count < 250 {
                   self.data.append(reading)
               } else {
                   self.data.remove(at: 0)
                   self.data.append(reading)
               }
           } else {
               return
           }
       }
}

struct LiveReadView_Previews: PreviewProvider {
    static var previews: some View {
        LiveReadView().preferredColorScheme(.dark)
    }
}
