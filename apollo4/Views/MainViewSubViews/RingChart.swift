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
    @State var loaded: Bool = false
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(getColor(value: progress))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(loaded ? self.progress: 0.0, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(getColor(value: progress))
                .rotationEffect(Angle(degrees: 270.0))
                .onAppear(){
                    withAnimation(Animation.easeInOut(duration: 1)){
                        loaded = true
                    }
                }
            Text(text)
                .bold()
                .font(.system(size: 500))
                .minimumScaleFactor(0.001)
                .scaleEffect(0.5)
        }
        //.frame(width: 100, height: 100, alignment: .center)
    }
    func getColor(value: Double) -> Color {
        switch value {
        case 0..<0.3:
            return Color.green
        case 0.3..<0.6:
            return Color.blue
        case 0.6..<0.8:
            return Color.orange
        case 0.8..<1.0:
            return Color.red
        default:
            return Color.red
    }
}

struct RingChart_Previews: PreviewProvider {
    static var previews: some View {
        RingChart(progress: .constant(0.5), text: .constant("28 BPM"))
    }
}
}
