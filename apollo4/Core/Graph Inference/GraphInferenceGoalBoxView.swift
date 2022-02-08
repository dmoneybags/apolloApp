//
//  GraphInferenceGoalBoxView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/29/22.
//

import SwiftUI

struct GraphInferenceGoalBoxView: View {
    var value: Double
    var above: Bool
    var didHitGoal: Bool
    var dataRange: Double?
    var dataMin: Double?
    var width: Double
    var height: Double
    var body: some View {
        ZStack{
            VStack{
                Text(didHitGoal ? "You hit your goal!" : "Goal not hit yet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(colors: [.purple, .orange], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
            }
            //.scaleEffect(CGSize(width: 1.0, height: -1.0))
            .position(x: 1.5 * width  - (1/2 * width), y: height)
            .zIndex(2)
            Line(start: CGPoint(x: width - (1/2 * width), y: getValueYposition()), end: CGPoint(x: 2 * width  - (1/2 * width), y: getValueYposition()))
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.orange)
                .frame(height: 1)
            LinearGradient(colors: above ? [.orange.opacity(0.3), .clear] : [.clear, .orange.opacity(0.3)], startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 0, y: 0))
                .frame(width: width, height: above ? getValueYposition() : height - getValueYposition())
                .position(x: width, y: 0)
                .offset(x: 0, y: above ? height/2 + getValueYposition() - (getValueYposition())/2 : height/2 + getValueYposition() + (height - getValueYposition())/2)
                .zIndex(-1)
        }
    }
    func getValueYposition() -> Double{
        return genYvalues(data: [value], ySize: height, dataRange: dataRange, dataMin: dataMin)[0]
    }
}

