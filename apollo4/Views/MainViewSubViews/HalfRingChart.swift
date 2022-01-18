//
//  HalfRingChart.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/16/22.
//

import SwiftUI

struct HalfRingChart: View {
    @Binding var allowsMovement: Bool
    @State var progress: Double = 0.0
    var minVal: Double
    var range: Double
    var text: String{
        String(format: "%.01f",((range * progress) + minVal))
    }
    var color: Color? = nil
    var stat: Stat? = nil
    init(statVal: Stat, reading: Double, moving: Binding<Bool>){
        self.minVal = Double(statVal.minVal)
        self.range = Double(statVal.maxVal - statVal.minVal)
        self._allowsMovement = moving
        self._progress = State(initialValue: (reading - minVal)/range)
        self.stat = statVal
    }
    init(minimum: Double, rangeVal: Double, reading: Double, colorVal: Color?, moving: Binding<Bool>){
        self.minVal = minimum
        self.range = rangeVal
        self._allowsMovement = moving
        self._progress = State(initialValue: (reading - minVal)/range)
        self.color = colorVal
    }
    var body: some View {
        ZStack{
            VStack {
                Text(text)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            GeometryReader{geo in
                Circle()
                    .trim(from: 0.5, to: 1.0)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color ?? getColor(stat: stat?.name ?? "", progress: progress))
                    .opacity(0.3)
                Circle()
                    .trim(from: 0.5, to: 1.0 - (0.5 - (0.5 * progress)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color ?? getColor(stat: stat?.name ?? "", progress: progress))
                    .opacity(0.7)
                Circle()
                    .trim(from: 0.0, to: 0.001)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: -180 + (180 * progress)))
                    .foregroundColor(color ?? getColor(stat: stat?.name ?? "", progress: progress))
                    .gesture(
                        LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture(minimumDistance: 10, coordinateSpace: .local))
                            .onChanged({ value in  // Get value of the gesture
                                if allowsMovement {
                                    switch value {
                                    case .second(true, let drag):
                                        if let longPressLocation = drag?.location {
                                            let minimum = geo.frame(in: .local).minX
                                            let maximum = geo.frame(in: .local).maxX
                                            progress = min(abs((longPressLocation.x - minimum)/(minimum - maximum)), 1.0)
                                        }
                                    default:
                                        
                                        break
                                    }
                                }
                            })
                        )
            }
        }
    }
}

struct HalfRingChart_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            HalfRingChart(statVal: HeartRate(), reading: 98.0, moving: .constant(true)).preferredColorScheme(.dark)
                .frame(width: 200, height: 200)
        }
    }
}
