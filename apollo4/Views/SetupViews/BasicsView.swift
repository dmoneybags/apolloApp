//
//  BasicsView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/17/22.
//

import SwiftUI

struct BasicSetupView<Content: View>: View {
    @ObservedObject var userData: UserData
    
    var title: String
    var color: Color
    var showSwipe: Bool = true
    @ViewBuilder var content: Content
    var body: some View {
        LazyVStack{
            HStack{
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .padding(.bottom, -20)
                Spacer()
            }
            .padding(.bottom)
            VStack{
                content
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height * 0.8)
            .background(.black).opacity(0.7)
            .cornerRadius(20)
            Spacer()
        }
        .background(LinearGradient(colors: [color, .black], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 0.85)))
    }
}
