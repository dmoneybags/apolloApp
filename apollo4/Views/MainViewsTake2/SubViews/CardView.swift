//
//  CardView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/15/21.
//

import SwiftUI
//Very sparse template simply takes in a name and color, the content passed in
//makes it very customizable
struct CardView<Content: View>: View {
    var name: String
    var backgroundColor: Color
    //for now until we finish them all
    var fullscreenData: statViewData? = nil
    @ViewBuilder var content: Content
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(backgroundColor)
                    .padding()
                Spacer()
            }
            self.content
        }
        .frame(width: 150, height: 200)
        .preferredColorScheme(.dark)
        .cornerRadius(20)
        //.shadow(color: Color(UIColor.systemGray2), radius: 5, x: 0, y: 0)
    }
}

