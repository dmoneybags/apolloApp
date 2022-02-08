//
//  BPDetailView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/3/21.
//

import SwiftUI

struct BPDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let SPPath: URL = getDocumentsDirectory().appendingPathComponent("SystolicPressure")
    let DPPath: URL = getDocumentsDirectory().appendingPathComponent("DiastolicPressure")
    var SPDailyData: [(Double, Date)] {
        return getData(filename: SPPath, timeFrame: .day)
    }
    var SPMonthlyData: [(Double, Date)] {
        return getData(filename: SPPath, timeFrame: .month)
    }
    var SPYearlyData: [(Double, Date)] {
        return getData(filename: SPPath, timeFrame: .year)
    }
    var DPDailyData: [(Double, Date)] {
        return getData(filename: DPPath, timeFrame: .day)
    }
    var DPMonthlyData: [(Double, Date)] {
        return getData(filename: DPPath, timeFrame: .month)
    }
    var DPYearlyData: [(Double, Date)] {
        return getData(filename: DPPath, timeFrame: .year)
    }
    var body: some View {
        VStack{
            ScrollView{
                ScrollViewReader { value in
                    Text("Blood Pressure")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                    Text("Blood pressure (BP) is the pressure of circulating blood against the walls of blood vessels. Most of this pressure results from the heart pumping blood through the circulatory system.")
                        .padding(.horizontal)
                        .font(.footnote)
                    Divider()
                    HStack{
                        SPO2MiniBox(title: "Pulse Pressure", imageName: "cross", stat: "PulsePressure", data: .constant(SPMonthlyData.map{$0.0}.last! - DPMonthlyData.map{$0.0}.last!))
                        HStack{
                            VStack{
                                CapsuleReader(reading: SPMonthlyData.map{$0.0}.last!, height: 100, stat: "SystolicPressure")
                                    .padding(.all, -10)
                                Text("Systolic")
                                    .font(.footnote)
                                    .padding(.horizontal, 5)
                            }
                            VStack{
                                CapsuleReader(reading: DPMonthlyData.map{$0.0}.last!, height: 100, stat: "DiastolicPressure")
                                    .padding(.all, -10)
                                Text("Diastolic")
                                    .font(.footnote)
                                    .padding(.horizontal, 5)
                            }
                        }
                        .frame(width: 150, height: 200, alignment: .center)
                        .padding()
                        .padding(.top, 30)
                        
                    }
                    TimeFrameMultiLineGrapher(stat1DailyData: SPDailyData, stat1MonthlyData: SPMonthlyData, stat1YearlyData: SPYearlyData, stat2DailyData: DPDailyData, stat2MonthlyData: DPMonthlyData, stat2YearlyData: DPYearlyData, statNames: ["Systolic", "Diastolic"])
                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded( { _ in
                            print("tap")
                            withAnimation(){
                                value.scrollTo(0, anchor: .bottom)
                            }
                        }))
                    VStack{
                        Divider()
                        HStack{
                            Text("Hypertension Risk")
                                .font(.title2)
                                .padding(.horizontal, 5)
                            Spacer()
                        }
                    }
                    .frame(width: 300, height: 40, alignment: .center)
                    .id(0)
                    HyperTensionBox(SystolicReading: averageData(data: SPMonthlyData.map{$0.0}), DiastolicReading: averageData(data: DPMonthlyData.map{$0.0}))
                }
            }
            backBtn()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 0.3)
        .padding(.bottom, 0.3)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

struct BPDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BPDetailView()
    }
}
