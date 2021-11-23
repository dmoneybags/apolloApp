//
//  GraphView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import SwiftUI

struct Line: Shape {
    var start, end: CGPoint

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}
extension Line {
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get { AnimatablePair(start.animatableData, end.animatableData) }
        set { (start.animatableData, end.animatableData) = (newValue.first, newValue.second) }
    }
}
func genXvalues(data: [Double], xSize: Double) -> [Double] {
    let dataLength = data.count
    var xPositions: [Double] = [Double]()
    for i in 0..<dataLength {
        let newElement: Double = Double(i) * (xSize/Double(dataLength))
        xPositions.append(newElement)
    }
    return xPositions
}
func genYvalues(data: [Double], ySize: Double) -> [Double] {
    let UsedYSize = ySize - 20
    let dataLength = data.count
    let dataRange = data.max()! - data.min()!
    var yPositions: [Double] = [Double]()
    for i in 0..<dataLength {
        let newElement = UsedYSize * ((data[i] - data.min()!)/dataRange) + 10
        yPositions.append(newElement)
    }
    return yPositions
}
func getLeadingVal(Positions: [Double], i: Int) ->  Double {
    if i == Positions.count - 1 {
        return Positions[i]
    } else {
        return Positions[i + 1]
    }
}
struct LineGraph: View {
    @Binding var data: [Double]
    @State var height: Double?
    @State var width: Double?
    @State var color: Color?
    @State var backgroundColor: Color?
    @State var heatGradient: Bool = false
    let tempGradient = Gradient(colors: [
      .purple,
      Color(red: 0, green: 0, blue: 139.0/255.0),
      .blue,
      Color(red: 30.0/255.0, green: 144.0/255.0, blue: 1.0),
      Color(red: 0, green: 191/255.0, blue: 1.0),
      Color(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0),
      .green,
      .yellow,
      .orange,
      Color(red: 1.0, green: 140.0/255.0, blue: 0.0),
      .red,
      Color(red: 139.0/255.0, green: 0.0, blue: 0.0)
    ])
    var body: some View {
        let yPositions = genYvalues(data: data, ySize: height!)
        let xPositions = genXvalues(data: data, xSize: width!)
        ZStack {
            ZStack {
                ForEach(data.indices, id: \.self) {i in
                    if heatGradient {
                        Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                            .stroke(LinearGradient(
                                gradient: self.tempGradient,
                                startPoint: UnitPoint(x: 0.0, y: 1.0),
                            endPoint: UnitPoint(x: 0.0, y: 0.0)), lineWidth: 2)
                    } else {
                        Line(start: CGPoint(x: xPositions[i], y: yPositions[i]), end: CGPoint(x: getLeadingVal(Positions: xPositions, i: i), y: getLeadingVal(Positions: yPositions, i: i)))
                            .stroke(color!, lineWidth: 2)
                    }
                }
                
                .frame(width: CGFloat(width!), height: CGFloat(height!))
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(backgroundColor != nil ? backgroundColor! : Color.black.opacity(0.0), lineWidth: 4))
            }
            .scaleEffect(CGSize(width: 1.0, height: -1.0))
        }.onTapGesture {
            print(yPositions)
            print(xPositions)
        }
    }
}
