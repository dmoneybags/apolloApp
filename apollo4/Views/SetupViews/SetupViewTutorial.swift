//
//  SetupViewTutorial.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/19/22.
//

import SwiftUI

struct SetupViewTutorial: View {
    @State var isShowing: Bool = true
    var body: some View {
        if isShowing {
            VStack{
                Spacer()
                VStack{
                    Text("Swipe left to continue")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Divider()
                    Spacer()
                    swipeView()
                        .scaleEffect(1.5)
                    Spacer()
                    Button("Got it", action: { isShowing.toggle()})
                        .padding()
                }
                .frame(width: 300, height: 300)
                .background(.black)
                .cornerRadius(20)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(.black.opacity(0.3))
        }
    }
}

struct SetupViewTutorial_Previews: PreviewProvider {
    static var previews: some View {
        SetupViewTutorial()
    }
}
