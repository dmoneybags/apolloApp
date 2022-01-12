//
//  InferenceInfoBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/11/22.
//

import SwiftUI

struct InferenceInfoBox: View {
    var doubleVal: Double
    var percent: Double
    var isHigher: Bool
    var gradient: Gradient
    var body: some View {
        VStack{
            Text(String(format: "%.01f", doubleVal))
                .fontWeight(.bold)
                .font(.title)
                .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
            Text(String(format: "%.01f", percent * 100) + (isHigher ? "% higher than average" : "% lower than average"))
                .font(.footnote)
                .foregroundStyle(LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                .padding(.horizontal)
        }
        .frame(width: 100, height: 120)
        .background(Color.white)
        .cornerRadius(20)
    }
}


