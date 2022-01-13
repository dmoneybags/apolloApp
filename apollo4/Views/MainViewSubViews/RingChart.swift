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
    @State var color: Color? = nil
    @State var fontSize: CGFloat? = nil
    @State var lineWidth: Double? = nil
    var body: some View {
        ZStack {
            GeometryReader{geo in
                Circle()
                    .stroke(lineWidth: lineWidth ?? 20.0)
                    .opacity(0.3)
                    .foregroundColor(color != nil ? color : getColor(stat: stat, progress: progress))
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(loaded ? self.progress: 0.0, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: lineWidth ?? 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color != nil ? color : getColor(stat: stat, progress: progress))
                    .rotationEffect(Angle(degrees: 270.0))
                    .opacity(0.7)
                    .onAppear(){
                        withAnimation(Animation.easeInOut(duration: 2)){
                            loaded = true
                        }
                    }
                if progress > 0 {
                    Circle()
                        .trim(from: 0.0, to: 0.001)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth ?? 20.0, lineCap: .round, lineJoin: .round))
                        .rotationEffect(Angle(degrees: 270 + (360 * progress)))
                        .foregroundColor(color != nil ? color : getColor(stat: stat, progress: progress))
                }
            }
            if imageName != nil {
                Image(systemName: imageName!)
                    .foregroundColor(Color.white)
            } else {
                VStack {
                    if text != "0" {
                        if fontSize == nil {
                            Text(text)
                                .bold()
                                .font(.system(size: 500))
                                .minimumScaleFactor(0.001)
                                .scaleEffect(0.5)
                        } else {
                            Text(text)
                                .bold()
                                .font(.system(size: fontSize!))
                        }
                    } else {
                        Text("No Data")
                            .bold()
                            .font(.system(size: 500))
                            .minimumScaleFactor(0.001)
                            .scaleEffect(0.4)
                    }
                }
            }
        }
    }
}

struct RingChart_Previews: PreviewProvider {
    static var previews: some View {
        RingChart(progress: .constant(0.2), text: .constant("28 BPM"))
    }
}

