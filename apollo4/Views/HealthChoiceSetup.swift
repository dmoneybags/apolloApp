//
//  HealthChoiceSetup.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/8/21.
//

import SwiftUI

struct HealthChoiceSetup: View {
    var body: some View {
        VStack {
            Text("Load data from Health app or input manually?")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Divider()
                .padding(.horizontal, 17.0)
            VStack {
                HStack {
                    Image(systemName: "heart.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                        .padding()
                    Image(systemName: "keyboard")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                        .padding()
                }
                .padding()
            }
        }
        .frame(width: 300, height: 400, alignment: .center)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .shadow(radius: 5)
    }
}

struct HealthChoiceSetup_Previews: PreviewProvider {
    static var previews: some View {
        HealthChoiceSetup()
    }
}
