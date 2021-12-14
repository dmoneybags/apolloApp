//
//  MainView2.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/10/21.
//

import SwiftUI

struct MainView2: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    var colors: [Color] {
        let color1 = colorScheme == .dark ? Color.black : Color.white
        let color2 = colorScheme == .dark ? Color.pink : Color.blue
        return [color1, color2]
    }
    var body: some View {
        ZStack (alignment: .top){
            TabView {
                DebugView()
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
        .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 0.0, y: 1.0)))
    }
}

struct MainView2_Previews: PreviewProvider {
    static var previews: some View {
        MainView2()
    }
}