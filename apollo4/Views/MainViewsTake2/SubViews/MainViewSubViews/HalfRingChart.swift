//
//  HalfRingChart.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/16/22.
//

import SwiftUI

class ObservableDouble: ObservableObject{
    @Published var value: Double
    init(val: Double){
        self.value = val
    }
}

struct HalfRingChart: View {
    @ObservedObject var twoWayProgress: ObservableDouble
    @Binding var allowsMovement: Bool
    @State var progress: Double = 0.0
    var minVal: Double
    var range: Double
    var text: String{
        String(format: "%.01f",((range * progress) + minVal))
    }
    var color: Color? = nil
    var stat: Stat? = nil
    var gradient: Gradient? = nil
    init(statVal: Stat, reading: Double, moving: Binding<Bool>, twoWayProgressVal: ObservableDouble? = nil){
        self.minVal = Double(statVal.minVal)
        self.range = Double(statVal.maxVal - statVal.minVal)
        if twoWayProgressVal != nil {
            self.twoWayProgress = twoWayProgressVal!
        } else {
            self.twoWayProgress = ObservableDouble(val: (reading - minVal)/range)
        }
        self._allowsMovement = moving
        self._progress = State(initialValue: (reading - minVal)/range)
        self.stat = statVal
    }
    init(minimum: Double, rangeVal: Double, reading: Double, colorVal: Color?, gradient: Gradient? = nil, moving: Binding<Bool>, twoWayProgressVal: ObservableDouble? = nil){
        self.minVal = minimum
        self.range = rangeVal
        if twoWayProgressVal != nil {
            self.twoWayProgress = twoWayProgressVal!
        } else {
            self.twoWayProgress = ObservableDouble(val: (reading - minVal)/range)
        }
        self._allowsMovement = moving
        self._progress = State(initialValue: (reading - minVal)/range)
        self.color = colorVal
        self.gradient = gradient
    }
    var body: some View {
        ZStack{
            VStack {
                Text(text)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                if stat != nil {
                    Text(stat!.measurement)
                }
            }
            GeometryReader{geo in
                if gradient == nil {
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
                        .rotationEffect(Angle(degrees: -180 + (180 * min(progress, 1))))
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
                                                twoWayProgress.value = progress
                                            }
                                        default:
                                            break
                                        }
                                    }
                                })
                            )
                } else {
                    Circle()
                        .trim(from: 0.5, to: 1.0)
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(AngularGradient(gradient: gradient!, center: .center))
                        .opacity(0.3)
                    Circle()
                        .trim(from: 0.5, to: 1.0 - (0.5 - (0.5 * progress)))
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(AngularGradient(gradient: gradient!, center: .center))
                        .opacity(0.7)
                    Circle()
                        .trim(from: 0.0, to: 0.001)
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .rotationEffect(Angle(degrees: -180 + (180 * min(progress, 1))))
                        .foregroundStyle(LinearGradient(gradient: gradient!, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 0)))
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
                                                twoWayProgress.value = progress
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
        .onAppear{
            twoWayProgress.value = progress
        }
    }
    static func getReading(progressVal: Double, rangeVal: Double, min: Double) -> Double {
        return  (rangeVal * progressVal) + min
    }
}

