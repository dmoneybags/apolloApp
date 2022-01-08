//
//  ECGAnimation.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/4/22.
//

import SwiftUI

struct ECGAnimation: View {
    private let gradient = Gradient(colors: [Color.black, Color.white, Color.black])
    @State private var xEnd: CGFloat = 0.1
    var body: some View {
        Image(systemName: "waveform.path.ecg")
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: xEnd, y: 0.0)))
            .onAppear(){
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)){
                    xEnd = 9.0
                }
            }
    }
}

struct ECGAnimation_Previews: PreviewProvider {
    static var previews: some View {
        ECGAnimation().preferredColorScheme(.dark)
    }
}
