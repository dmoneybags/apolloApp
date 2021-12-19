//
//  CardView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/15/21.
//

import SwiftUI

struct CardView<Content: View>: View {
    var name: String
    var backgroundColor: Color
    @ViewBuilder var content: Content
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .fontWeight(.bold)
                    .font(.title3)
                    .padding()
                Spacer()
            }
            self.content
        }
        .frame(width: 150, height: 200)
        .background(backgroundColor)
        .preferredColorScheme(.dark)
        .cornerRadius(20)
        .shadow(color: Color(UIColor.systemGray2), radius: 5, x: 0, y: 0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(name: "Heart Rate Variability", backgroundColor: Color.blue){
            RingChart(progress: .constant(0.7), text: .constant("40")).padding()
        }
    }
}
