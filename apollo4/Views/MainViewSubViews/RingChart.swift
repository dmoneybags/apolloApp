//
//  RingChart.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/19/21.
//

import SwiftUI

struct RingChart: View {
    @Binding var progress: Double
    @Binding var text: String
    @State var imageName: String?
    @State var loaded: Bool = false
    @State var stat: String = "SPO2"
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(getColor(stat: stat, progress: progress))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(loaded ? self.progress: 0.0, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(getColor(stat: stat, progress: progress))
                .rotationEffect(Angle(degrees: 270.0))
                .onAppear(){
                    withAnimation(Animation.easeInOut(duration: 1)){
                        loaded = true
                    }
                }
            if imageName != nil {
                Image(systemName: imageName!)
                    .foregroundColor(Color.white)
            } else {
                Text(text)
                    .bold()
                    .font(.system(size: 500))
                    .minimumScaleFactor(0.001)
                    .scaleEffect(0.5)
            }
        }
        //.frame(width: 100, height: 100, alignment: .center)
    }
}

struct RingChart_Previews: PreviewProvider {
    static var previews: some View {
        RingChart(progress: .constant(0.2), text: .constant("28 BPM"))
    }
}

