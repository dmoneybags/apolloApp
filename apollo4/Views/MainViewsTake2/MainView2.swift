//
//  MainView2.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/10/21.
//

import SwiftUI

struct MainView2: View {
    @Environment(\.colorScheme) var colorScheme
    //Colors for light and dark mode, however app may be forced to dark mode because I just like it
    var colors: [Color] {
        let color1 = colorScheme == .dark ? Color.black : Color.white
        let color2 = colorScheme == .dark ? Color.pink : Color.blue
        return [color1, color2]
    }
    var body: some View {
        //ZStack so logo is always on top
        ZStack (alignment: .top){
            TabView {
                //Shows vitals like HR, SPO2, Blood pressure
                VitalView()
                    .tabItem {
                        Label("Vitals", systemImage: "heart.fill")
                }
                //Shows fonts for easy viewing
                FontView()
                    .tabItem {
                        Label("Live Read", systemImage: "waveform.path.ecg")
                }
            }
            Image(colorScheme == .dark ? "logowhttrans": "logo_white_background")
                .resizable()
                .frame(width: 100, height: 50, alignment: .center)
                .padding(.top, 30)
        }
        .ignoresSafeArea(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct MainView2_Previews: PreviewProvider {
    static var previews: some View {
        MainView2()
    }
}
