//
//  LiveRead.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import SwiftUI

struct LiveRead: View {
    @State private var opacityAnimator = 0.4
    @State private var data: [Double] = [0, 5, 0, 7, 0, 10]
    @State private var reading = false
    var body: some View {
        VStack{
            Text("Live Read")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.systemGray6))
            Divider()
            Text("Place your hand on a steady surface and take deep breaths")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(Color(UIColor.systemGray6))
            LineGraph(data: $data, height: 280, width: 280, color: Color.red, heatGradient: true)
            Text("Start")
                .font(.title2)
                .frame(width: 70, height: 70)
                .opacity(opacityAnimator)
                .padding()
                .foregroundColor(Color.white)
                .onAppear(){
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)){
                        opacityAnimator = 1.0
                    }
                }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct LiveRead_Previews: PreviewProvider {
    static var previews: some View {
        LiveRead()
    }
}
