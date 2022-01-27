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
    case loading
    case finished
}

struct LiveReadView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var bleManager: BLEManager = .shared
    @ObservedObject var stopWatchManager = StopWatchManager(timeLim: 20.0)
    @State var data: [Double] = []
    @State private var readingAnimator = 0.2
    @State private var state: LiveReadState = .preread
    @State private var fakeData : [Double] = genFakeData()
    let rawPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "Raw"))
    var body: some View {
        VStack{
            HStack {
                Text("Check Your Waveform")
                    .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            if state == .finished {
                Text("In the future a popup will come up with data")
            } else {
                Text("Debug View for now")
            }
            if state == .preread || state == .loading{
                LineGraph(data: $fakeData, dataTime: .constant(nil), height: 400, width: UIScreen.main.bounds.width, gradient: Gradient(colors: [Color.purple, Color.blue]), useLines: false)
                    .onAppear(){
                        DispatchQueue.main.async(){
                            withAnimation(Animation.easeOut(duration: 3.0).repeatForever()){
                                fakeData = fakeData.reversed()
                            }
                        }
                    }
                    .allowsHitTesting(false)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 4)
                        )
            } else {
                LineGraph(data: $data, dataTime: .constant(nil), height: 400, width: UIScreen.main.bounds.width, gradient: Gradient(colors: [Color.purple, Color.blue]), useLines: false)
                    .allowsHitTesting(false)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 4)
                        )
            }
            if state == .preread {
                Button(action: startRaw){
                    Text("Start")
                        .font(.title2)
                }
                .padding()
                .buttonStyle(.bordered)
                Divider()
                    .padding(.horizontal, 130)
                Button("Exit", role: .destructive){
                    presentationMode.wrappedValue.dismiss()
                }
            } else if state == .reading {
                HStack{
                    RingChart(progress: $stopWatchManager.progress, text: .constant(String(format: "%0.1f", stopWatchManager.secondsElapsed)), color: Color.blue, fontSize: 12)
                        .frame(width: 75, height: 75)
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
            } else if state == .loading {
                Text("Loading")
                    .font(.title)
                    .padding()
                    .opacity(readingAnimator)
                    .onAppear(){
                        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()){
                            readingAnimator = 1.0
                        }
                    }
            } else { //State == .finished
                Button(action: startRaw){
                    Text("Read Again")
                        .font(.title2)
                }
                .padding()
                .buttonStyle(.bordered)
                Divider()
                    .padding(.horizontal, 130)
                Button("Exit", role: .destructive){
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onReceive(rawPub){output in
            if data.count > 99 && (state == .loading){
                state = .reading
                stopWatchManager.start()
            }
            let reading = (output.object as? NSString)!.doubleValue
            print("Got reading of \(reading)")
            genHeartBeatList(reading: reading)
        }
        .onChange(of: stopWatchManager.mode){mode in
            if mode == .stopped {
                state = .finished
                stopWatchManager.stop()
                let off = withUnsafeBytes(of: 0x00) { Data($0) }
                bleManager.connectedPeripheral!._CBPeripheral.writeValue(off, for: (bleManager.connectedPeripheral!.characteristics["isRaw"])!, type: .withoutResponse)
            }
        }
    }
    public func startRaw(){
        print("Changing to raw mode; sending requests")
        let on = withUnsafeBytes(of: 0x01) { Data($0) }
        bleManager.connectedPeripheral!._CBPeripheral.writeValue(on, for: (bleManager.connectedPeripheral!.characteristics["isRaw"])!, type: .withoutResponse)
        print("Sent Requests")
        state = .loading
        data = [150, 150]
    }
    func genHeartBeatList(reading: Double){
       if reading != 0.0 {
           if self.data.count < 100 {
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
fileprivate func genFakeData() -> [Double]{
    var fakeData : [Double] = []
    for i in 0..<100{
        fakeData.append(sin(Double(i)/5) * 150 + 150)
    }
    return fakeData
}
