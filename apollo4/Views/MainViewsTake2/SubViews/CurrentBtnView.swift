//
//  CurrentBtnView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/7/22.
//

import SwiftUI

struct CurrentBtnView: View {
    var dataValStr: String
    var currentView: AnyView
    @State private var showingCurrent: Bool = false
    var body: some View {
        VStack(spacing: 5) {
            Text(dataValStr)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            Divider()
                .padding(.horizontal)
            Button {
                showingCurrent = true
            } label: {
                Text("Current")
            }
        }
        .frame(maxWidth: 100)
        .fullScreenCover(isPresented: $showingCurrent){
            currentView
        }
    }
}
