//
//  InferenceMultiLineAverageBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/11/22.
//

import SwiftUI

struct InferenceMultiLineAverageBox: View {
    var gradients: [Gradient]
    var names: [String]
    @State private var scaleEffect: Bool = false
    var body: some View {
        VStack(spacing: 5){
            Text("Averages")
                .font(.footnote)
                .fontWeight(.bold)
            Divider()
                .padding(.horizontal)
            ForEach(names.indices, id: \.self){i in
                HStack{
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(LinearGradient(gradient: gradients[i], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                        .padding(.horizontal, 5)
                    Spacer()
                    Text(names[i])
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal)
                }
                .frame(height: 20)
            }
        }
        .frame(width: 180, height: 30 + CGFloat(gradients.count) * 30)
        .background(.black)
        .cornerRadius(20)
        .scaleEffect(scaleEffect ? 1.5: 1.0)
        .offset(x: scaleEffect ? -20: 0, y: 0)
        .onTapGesture {
            withAnimation(){
                scaleEffect.toggle()
            }
        }
    }
}

struct InferenceMultiLineAverageBox_Previews: PreviewProvider {
    static var previews: some View {
        InferenceMultiLineAverageBox(gradients: [Gradient(colors: [.pink, .purple]), Gradient(colors: [.green, .blue])], names: ["Systolic Pressure", "Diastolic Pressure"]).preferredColorScheme(.dark)
    }
}
