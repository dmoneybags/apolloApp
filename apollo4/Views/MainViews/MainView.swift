//
//  MainView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/18/21.
//

import SwiftUI
///EITHER FILTER DATA HERE OR IN VIEWS FOR SMOOTHER GRAPHS
struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var inDetail: Bool = false
    @State var detailStat: String = ""
    let detailPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: "vitalView"))
    let SPO2Path = getDocumentsDirectory().appendingPathComponent("SPO2")
    let HeartRatePath = getDocumentsDirectory().appendingPathComponent("HeartRate")
    let SPPath = getDocumentsDirectory().appendingPathComponent("SystolicPressure")
    let DPPath = getDocumentsDirectory().appendingPathComponent("DiastolicPressure")
    var body: some View {
        ZStack{
            VStack {
                ScrollView {
                    Option1(filename: .constant(SPO2Path), title: .constant("SPO2"), stat: "SPO2", dailyData: getData(filename: SPO2Path, timeFrame: .day), monthlyData: getData(filename: SPO2Path, timeFrame: .month), yearlyData: getData(filename: SPO2Path, timeFrame: .year))
                        .onTapGesture {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "vitalView"), object: "SPO2")
                        }
                    Option2(filename: .constant(HeartRatePath), title: .constant("BPM"), dailyData: getData(filename: HeartRatePath, timeFrame: .day), monthlyData: getData(filename: HeartRatePath, timeFrame: .month), yearlyData: getData(filename: HeartRatePath, timeFrame: .year))
                        //.padding(.bottom)
                        .onTapGesture {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "vitalView"), object: "BPM")
                        }
                    BPOption1(SPfileName: SPPath, DPfileName: DPPath, title: "Blood Pressure", SPdailyData: getData(filename: SPPath, timeFrame: .day), SPmonthlyData: getData(filename: SPPath, timeFrame: .month), DPdailyData: getData(filename: DPPath, timeFrame: .day), DPmonthlyData: getData(filename: DPPath, timeFrame: .year))
                        .onTapGesture {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "vitalView"), object: "BP")
                        }
                }
            }
            .onReceive(detailPub){output in
                detailStat = output.object as! String
                if detailStat == "exit"{
                    inDetail = false
                } else {
                    inDetail = true
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 0.3)
            .padding(.bottom, 0.3)
            .background(Color(UIColor.systemGray6))
            if inDetail {
                containedView(stat: detailStat)
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity).animation(.easeInOut(duration: 0.7)))
                    .zIndex(2)
            }
        }
    }
    func containedView(stat: String) -> AnyView {
        switch stat {
        case "BPM": return AnyView(BPMDetailView())
        case "SPO2": return AnyView(SPO2DetailView())
        default: return AnyView(EmptyView())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.dark)
    }
}
