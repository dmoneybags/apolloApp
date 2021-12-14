//
//  CapsuleGraph.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/28/21.
//

import SwiftUI

struct CapsuleGraph: View {
    @Binding var data: [Double]?
    @Binding var dataTime: [(Double, Date)]?
    @State var dataRange: Double?
    @State var height: Double
    @State var width: Double
    @State var gradient: Gradient = Gradient(colors: [Color.pink, Color.blue])
    var body: some View {
        let yPositions = genYvalues(data: (dataTime != nil ? dataTime!.map{$0.0}:data)!, ySize: height, dataRange: nil, dataMin: nil)
        let xPositions = genXvalues(data: (dataTime != nil ? dataTime!.map{$0.0}:data)!, xSize: width)
        let fakeXPositions = getUnloadedYpositions(yPositions: xPositions)
        let capsuleWidth = CGFloat(Int(width/Double(dataTime!.count)))
        let linearGradient = LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
        if dataTime?.map{$0.0}.count != 1 {
            VStack{
                ZStack{
                    graphLines(width: width, height: height, data: dataTime!, forCapsule: true)
                    if dataTime!.count != 1{
                        GeometryReader { geo in
                            ForEach(dataTime!.indices, id: \.self){i in
                                Capsule()
                                    .frame(width: capsuleWidth, height: (yPositions[i]) + 5)
                                    .position(x: geo.frame(in: .local).minX + 5 + capsuleWidth/2 + xPositions[i], y: geo.frame(in: .local).minY + yPositions[i]/2)
                                    .foregroundStyle(linearGradient)
                            }
                        }
                    }
                }
                .scaleEffect(CGSize(width: 1.0, height: -1.0))
                .frame(width: CGFloat(width), height: CGFloat(height))
            }
        } else {
            Text("No Data")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.systemGray))
                .frame(width: CGFloat(width), height: CGFloat(height))
        }
    }
}

struct CapsuleGraph_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleGraph(data: .constant(nil), dataTime: .constant([(150.0, Date()), (117.0, Date()), (117.0, Date()), (118.0, Date()), (119.0, Date())]), height: 300, width: 300).preferredColorScheme(.dark)
    }
}
