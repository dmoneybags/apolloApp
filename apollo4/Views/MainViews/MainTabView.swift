//
//  MainTabView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/26/21.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack (alignment: .top){
            TabView {
                MainView()
                    .tabItem {
                        Label("Vitals", systemImage: "heart.fill")
                }
                MainLiveRead()
                    .tabItem {
                        Label("Live Read", systemImage: "waveform.path.ecg")
                }
            }
            Image(colorScheme == .dark ? "logowhttrans": "logo_white_background")
                .resizable()
                .frame(width: 100, height: 50, alignment: .center)
                .padding(.top, 30)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView().preferredColorScheme(.dark)
    }
}
