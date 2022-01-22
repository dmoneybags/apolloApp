//
//  TickMarkReader.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/5/21.
//

import SwiftUI

struct TickMarkReader: View {
    var length: Double = 400
    var width: Double = 30
    var stat: String
    var reading: Double
    var color: Color? = nil
    var showNum: Bool = true
    @State private var loaded = false
    private var progress: Double{
        return getProgress(stat: stat, reading: reading)
    }
    private var readingLength: Double{
        return progress * length
    }
    var body: some View {
        let xPositions = genXpositions()
        let yPositions = genYpositions()
        ZStack{
            GeometryReader { geo in
                ForEach(xPositions.indices, id: \.self){indice in
                    Line(start: CGPoint(x: xPositions[indice], y: yPositions[indice]), end: CGPoint(x: width - xPositions[indice], y: yPositions[indice]))
                        .stroke(Color(UIColor.systemGray3))
                }
                Capsule()
                    .frame(width: width, height: loaded ? readingLength: 0, alignment: .center)
                    .position(x: geo.frame(in: .local).midX, y: loaded ? geo.frame(in: .local).maxY - readingLength/2 : geo.frame(in: .local).maxY)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.clear, (color != nil ? color!: getColor(stat: stat, progress: progress))]), startPoint: UnitPoint(x: 0.0, y: 1.0), endPoint: UnitPoint(x: 0.0, y: 0.0)))
                if showNum {
                    HStack{
                        Text(String(Int(reading)))
                            .fontWeight(.bold)
                            .font(.title2)
                        Image(systemName: "play")
                    }
                    .frame(width: 80, height: 30, alignment: .center)
                    .position(x: geo.frame(in: .local).minX - 40, y: geo.frame(in: .local).maxY - readingLength)
                }
            }
        }
        .onAppear(){
            withAnimation(Animation.easeInOut(duration: 2.0)){
                loaded = true
            }
        }
        .frame(width: width, height: length, alignment: .center)
    }
    private func genYpositions() -> [Double] {
        var yPositions: [Double] = []
        let numLines = Int(length/20 - 1)
        let increment : Double = 20
        for lineNum in 1...numLines{
            yPositions.append(Double(lineNum) * increment)
        }
        return yPositions
    }
    private func genXpositions() -> [Double]{
        var xPositions: [Double] = []
        let numLines = Int(length/20 - 1)
        for lineNum in 1...numLines{
            var xPosition = width/4
            if lineNum % 2 == 0{
                xPosition = width/8
            }
            if lineNum % 4 == 0{
                xPosition = 0
            }
            xPositions.append(xPosition)
        }
        return xPositions
    }
}

struct TickMarkReader_Previews: PreviewProvider {
    static var previews: some View {
        TickMarkReader(stat: "SPO2", reading: 94.0).preferredColorScheme(.dark)
    }
}
