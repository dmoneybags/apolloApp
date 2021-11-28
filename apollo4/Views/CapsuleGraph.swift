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
    @State var height: Double
    @State var width: Double
    var body: some View {
        let yPositions = genYvalues(data: (dataTime != nil ? dataTime!.map{$0.0}:data)!, ySize: height, dataRange: nil, dataMin: nil)
        let fakeXPositions = getUnloadedYpositions(yPositions: xPositions)
        let xPositions = genXvalues(data: (dataTime != nil ? dataTime!.map{$0.0}:data)!, xSize: width)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CapsuleGraph_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleGraph(data: .constant(nil), dataTime: .constant([(150.0, Date()), (117.0, Date()), (117.0, Date()), (118.0, Date()), (119.0, Date())]))
    }
}
