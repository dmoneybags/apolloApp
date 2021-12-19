//
//  HorizontalCapsuleReader.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/7/21.
//

import SwiftUI

struct HorizontalCapsuleReader: View {
    var progress: Double
    var width: Double
    var height: Double
    var gradient: Gradient
    var body: some View {
        ZStack{
            Capsule()
                .frame(width: width, height: height)
                .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 0.0)))
            Circle()
                .frame(width: height, height: height)
                .position(x: (width) * progress - 7.5, y: 7.5)
                .foregroundColor(Color.white)
        }
        .frame(width: width, height: height)
        .scaleEffect(CGSize(width: -1.0, height: 1.0))
    }
}

struct HorizontalCapsuleReader_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCapsuleReader(progress: 0.99, width: 100, height: 15, gradient: rangeGradient).preferredColorScheme(.dark)
    }
}
