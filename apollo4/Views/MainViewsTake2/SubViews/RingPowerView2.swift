//
//  RingPowerView2.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/21/22.
//
fileprivate let totalBatteryLife: Double = 259200
import SwiftUI
import SceneKit

struct RingPowerView2: View {
    @ObservedObject var changingRingSettings: observableBool
    @State private var opacityAnimator: Bool = false
    private let exampleRingBatteryLevel: Double = 0.9
    private let width = UIScreen.main.bounds.width/1.2
    var body: some View {
        ZStack{
            Color.black
                .opacity(opacityAnimator ? 0.4 : 0.0)
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            VStack{
                HStack{
                    Text("Ring Battery Level")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundStyle(LinearGradient(gradient: getGradient(for: exampleRingBatteryLevel), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                        .padding([.leading, .trailing, .top], 15)
                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                        .foregroundColor(Color(UIColor.systemGray))
                        .onTapGesture(){
                            changingRingSettings.value = false
                        }
                }
                Divider()
                HStack{
                    LineGraph(data: .constant([0.99, 0.96, 0.87, 0.95, 0.94, 0.92, 0.91, 0.9]), dataTime: .constant(nil), height: width/2, width: width/2, gradient: getGradient(for: exampleRingBatteryLevel), title: "Percent over time", useLines: false, pooledData: true)
                        .frame(width: width/2, height: width/2)
                        .padding(.horizontal)
                    Spacer()
                    ZStack{
                        TickMarkReader(length: width/2, width: width/6, stat: "SPO2", reading: 96, color: .green, showNum: false)
                        Image(systemName: "battery.0")
                            .resizable()
                            .frame(width: width/2, height: width/5)
                            .aspectRatio(1.0, contentMode: .fill)
                            .rotationEffect(Angle(degrees: 270))
                    }
                    .frame(width: width/5, height: width/5)
                    .padding(.horizontal)
                }
                Divider()
                HStack{
                    VStack{
                        Text("Charged until:")
                            .fontWeight(.bold)
                        Text(getTimeComponent(date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 + TimeInterval(exampleRingBatteryLevel * totalBatteryLife)), timeFrame: .day))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(LinearGradient(gradient: getGradient(for: exampleRingBatteryLevel), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                    }
                    .frame(width: width/1.6)
                    Divider()
                    Text(String(Int(exampleRingBatteryLevel * 100)) + "%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(LinearGradient(gradient: getGradient(for: exampleRingBatteryLevel), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                        .padding(.horizontal)
                }
                .frame(height: width/6)
                .padding(.bottom)
            }
            .frame(width: width, height: width)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
        }
        .onAppear(){
            withAnimation(.easeInOut(duration: 1.5)){
                opacityAnimator = true
            }
        }
    }
    func getGradient(for powerLevel: Double) -> Gradient{
        switch powerLevel{
        case -.infinity..<0.2: return Gradient(colors: [.red, .orange])
        case 0.2..<0.5: return Gradient(colors: [.orange, .yellow])
        case 0.5..<0.8: return Gradient(colors: [.green, .yellow])
        default: return Gradient(colors: [.green, .blue])
        }
    }
}

struct RingPowerView2_Previews: PreviewProvider {
    static var previews: some View {
        RingPowerView2(changingRingSettings: observableBool(value: true)).preferredColorScheme(.dark)
    }
}
