//
//  MainView2.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/10/21.
//

import SwiftUI
import NotificationBannerSwift
class observableBool: ObservableObject {
    @Published var value: Bool
    init(value: Bool){
        self.value = value
    }
}

struct MainView2: View {
    @Environment(\.colorScheme) var colorScheme
    //Colors for light and dark mode, however app may be forced to dark mode because I just like it
    @StateObject private var changingRingSettings: observableBool = observableBool(value: false)
    @EnvironmentObject var bleManager: BLEManager
    var showSuccess = false
    var colors: [Color] {
        let color1 = colorScheme == .dark ? Color.black : Color.white
        let color2 = colorScheme == .dark ? Color.pink : Color.blue
        return [color1, color2]
    }
    private let successBanner = NotificationBanner(title: "Sucess!",  subtitle: "Ring set up!", style: .success)
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
            HStack{
                SettingsView()
                    .offset(x: 30, y: 30)
                    .frame(width: 30, height: 30)
                    .zIndex(4)
                Spacer()
                Image(colorScheme == .dark ? "logowhttrans": "logo_white_background")
                    .resizable()
                    .frame(width: 100, height: 50, alignment: .center)
                    .padding(.top, 30)
                Spacer()
                ZStack{
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                    Image(systemName: "bolt.fill")
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                    RingChart(progress: .constant(0.85), text: .constant(""), lineWidth: 5)
                        .frame(width: 35, height: 35)
                    if changingRingSettings.value{
                        ZStack{
                            RingPowerView2(changingRingSettings: changingRingSettings)
                                .position(x: -UIScreen.main.bounds.width/2 + 62.5, y: UIScreen.main.bounds.height/2 - 50)
                        }
                    }
                }
                .zIndex(3)
                .offset(x: -30, y: 30)
                .frame(width: 30, height: 30)
                .onTapGesture {
                    print("Showing battery level view")
                    changingRingSettings.value = true
                }
            }
        }
        .onAppear{
            if showSuccess{
                successBanner.show()
            }
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
