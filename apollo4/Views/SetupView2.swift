//
//  SetupView2.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/10/21.
//

import SwiftUI

struct SetupView2: View {
    var body: some View {
        VStack{
            VStack{
                
            }
            .frame(width: 350, height: 600, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 20).fill(Colo))
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.blue]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 2)))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SetupView2_Previews: PreviewProvider {
    static var previews: some View {
        SetupView2()
    }
}
