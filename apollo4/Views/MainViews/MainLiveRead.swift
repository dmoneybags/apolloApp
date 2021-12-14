//
//  MainLiveRead.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/25/21.
//

import SwiftUI

struct MainLiveRead: View {
    //Code this part
    var liveViews: [Any] = [1]
    @Environment(\.colorScheme) var colorScheme
    @State var selector = 0
    @State var bpmData: [Double] = [0.0]
    @State var SPO2Data: [Double] = [0.0]
    @State var bpData: [[Double]] = [[0.0],[0.0]]
    let bpmPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "HeartRate"))
    let SPO2Pub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "SPO2"))
    let sysPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "SystolicPressure"))
    let diaPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "DiastolicPressure"))
    var body: some View {
        VStack {
            HStack {
                ForEach(liveViews.indices, id: \.self){index in
                    Circle()
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(selector == index ? Color.blue : Color(UIColor.systemGray3))
                }
            }
            Divider()
            containedView()
        }
        .onReceive(bpmPub){reading in
            let value = (reading.object as! NSString).doubleValue
            if value != 0.0{
                if bpmData.count < 50 {
                    withAnimation(){
                        bpmData.append(value)
                    }
                } else {
                    bpmData.remove(at: 0)
                    withAnimation(){
                        bpmData.append(value)
                    }
                }
            } else {
                return
            }
        }
        .onReceive(SPO2Pub){reading in
            let value = (reading.object as! NSString).doubleValue
            if value != 0.0{
                if SPO2Data.count < 50 {
                    withAnimation(){
                        SPO2Data.append(value)
                    }
                } else {
                    SPO2Data.remove(at: 0)
                    withAnimation(){
                        SPO2Data.append(value)
                    }
                }
            } else {
                return
            }
        }
        .onReceive(sysPub){reading in
            let value = (reading.object as! NSString).doubleValue
            if value != 0.0{
                if bpData[0].count < 50 {
                    withAnimation(){
                        bpData[0].append(value)
                    }
                } else {
                    bpData[0].remove(at: 0)
                    withAnimation(){
                        bpData[0].append(value)
                    }
                }
            } else {
                return
            }
        }
        .onReceive(diaPub){reading in
            let value = (reading.object as! NSString).doubleValue
            if value != 0.0{
                if bpData[1].count < 50 {
                    withAnimation(){
                        bpData[1].append(value)
                    }
                } else {
                    bpData[1].remove(at: 0)
                    withAnimation(){
                        bpData[1].append(value)
                    }
                }
            } else {
                return
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            if selector < liveViews.count - 1{
                                selector += 1
                            }
                        } else if value.translation.width > 0 {
                            if selector > 0 {
                                selector -= 1
                            }
                        }
                    }))
    }
    func containedView() -> AnyView {
        switch selector {
            case 0: return AnyView(LiveGrapher(bpmData: $bpmData, SPO2Data: $SPO2Data, bpData: $bpData))
            default: return AnyView(LiveGrapher(bpmData: $bpmData, SPO2Data: $SPO2Data, bpData: $bpData))
                
        }
    }
}

struct MainLiveRead_Previews: PreviewProvider {
    static var previews: some View {
        MainLiveRead()
    }
}
