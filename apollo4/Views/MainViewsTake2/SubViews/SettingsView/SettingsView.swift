//
//  SettingsView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/21/22.
//

//My account
    //View my account
    //Log out
    //Delete my account
//Share Data
    //Text
    //Email
    //Save to my phone
//Ring Settings
    //View my ring data
    //Change bluetooth settings
    //Advanced settings
    //Disconnect
//Pair new ring
//Health app sharing
//Erase Data
//Privacy Policy
//Contact us

import SwiftUI
struct SettingItem {
    var name: String
    //Only necessary for top level settings
    var iconName: String? = nil
    var destructive: Bool = false
    var view: AnyView? = nil
    var children: [SettingItem]? = nil
    var color: Color{
        if view == nil {
            return .white
        } else if destructive {
            return .red
        } else {
            return .blue
        }
    }
}
struct SettingsView: View {
    @State private var show: Bool = false
    private let settingValues: [SettingItem] = [
        SettingItem(name: "My Account", iconName: "person.circle.fill",
        children: [
            SettingItem(name: "View My Account", view: AnyView(
                BasicSettingView(title: "My Account"){
                ProfileView()
            })),
            SettingItem(name: "Log Out", view: AnyView(EmptyView())), SettingItem(name: "Delete My account", destructive: true, view: AnyView(EmptyView()))
        ]),
        SettingItem(name: "Share data", iconName: "network",
        children: [
            SettingItem(name: "Text", iconName: "message", view: AnyView(EmptyView())),
            SettingItem(name: "Email", iconName: "tray.fill", view: AnyView(EmptyView())),
            SettingItem(name: "Save Data To My Phone", iconName: "square.and.arrow.down.fill", view: AnyView(EmptyView()))
        ]),
        SettingItem(name: "Ring Settings", iconName: "bolt.fill",
        children: [
            SettingItem(name: "View My Ring Info", iconName: "info.circle.fill", view: AnyView(EmptyView())),
            SettingItem(name: "Change Bluetooth Settings", iconName: "personalhotspot", view: AnyView(EmptyView())),
            SettingItem(name: "Advanced Settings", iconName: "magnifyingglass.circle.fill", view: AnyView(EmptyView())),
            SettingItem(name: "Disconnect Ring", iconName: "x.circle.fill", destructive: true, view: AnyView(EmptyView()))
        ]),
        SettingItem(name: "Appearance Settings", iconName: "eyedropper", view: AnyView(EmptyView())),
        SettingItem(name: "Health App Sharing", iconName: "heart.fill", view: AnyView(EmptyView())),
        SettingItem(name: "Privacy Policy", iconName: "mail.and.text.magnifyingglass", view: AnyView(EmptyView())),
        SettingItem(name: "Contact Us", iconName: "phone.fill.arrow.down.left", view: AnyView(EmptyView())),
        SettingItem(name: "Erase My Data", iconName: "person.crop.circle.fill.badge.minus", destructive: true, view: AnyView(EmptyView()))
    ]
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding([.leading, .top, .trailing], show ? 15: 0)
                    .onTapGesture{
                        print("TAPPED, toggling show: \(show)")
                        withAnimation{
                            show.toggle()
                        }
                    }
                if show {
                    Spacer()
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .padding(.trailing, 50)
                        .padding(.top)
                    Spacer()
                }
            }
            .padding(.top, show ? 50: 0)
            if show {
                Divider()
                ScrollView{
                    ForEach(settingValues.indices, id: \.self){indice in
                        SettingRow(setting: settingValues[indice])
                    }
                }
                Spacer()
            }
        }
        .frame(width: show ? UIScreen.main.bounds.width: 40, height: show ? UIScreen.main.bounds.height - 10: 40)
        .background(.black)
        .onTapGesture{
            if !show{
                print("TAPPED, toggling show: \(show)")
                show = true
            }
        }
        .cornerRadius(20)
        .offset(x: show ? UIScreen.main.bounds.width/2 - 45: 0, y: show ? UIScreen.main.bounds.height/2 - 95: 0)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            SettingsView().preferredColorScheme(.dark)
            
        }
    }
}
