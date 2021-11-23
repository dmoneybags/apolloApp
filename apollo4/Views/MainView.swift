//
//  MainView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/18/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ScrollView {
            Image("logowhttrans")
                .resizable()
                .frame(width: 150, height: 75, alignment: .center)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
