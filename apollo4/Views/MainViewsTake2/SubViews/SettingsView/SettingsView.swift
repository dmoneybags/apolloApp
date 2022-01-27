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
    var action: (() -> Void)? = nil
    var alertTitle: String? = nil
    var children: [SettingItem]? = nil
    var url: URL? = nil
    //for email
    var sheet: AnyView? = nil
    var color: Color{
        if view == nil && action == nil && url == nil && sheet == nil{
            return .white
        } else if destructive {
            return .red
        } else {
            return .blue
        }
    }
    init(name: String, iconName: String? = nil, destructive: Bool = false, view: AnyView? = nil){
        self.name = name
        self.iconName = iconName
        self.destructive = destructive
        self.view = view
    }
    init(name: String, iconName: String? = nil, children: [SettingItem]){
        self.name = name
        self.iconName = iconName
        self.children = children
    }
    init(name: String, iconName: String? = nil, action: @escaping () -> Void){
        self.name = name
        self.iconName = iconName
        self.action = action
    }
    init(name: String, iconName: String? = nil, action: @escaping () -> Void, view: AnyView){
        self.name = name
        self.iconName = iconName
        self.action = action
        self.view = view
    }
    init(name: String, iconName: String? = nil, action: @escaping () -> Void, view: AnyView, alertTitle: String){
        self.init(name: name, iconName: iconName, action: action, view: view)
        self.alertTitle = alertTitle
    }
    init(name: String, iconName: String? = nil, url: URL){
        self.name = name
        self.iconName = iconName
        self.url = url
    }
    init(name: String, iconName: String? = nil, sheet: AnyView? = nil){
        self.name = name
        self.iconName = iconName
        self.sheet = sheet
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
            SettingItem(name: "Log Out", action: {
                Backend.shared.signOut()
            }, view: AnyView(SigningOutView()), alertTitle: "Are you sure you want to sign out of your account?"),
            SettingItem(name: "Delete My account", destructive: true, view: AnyView(SigningOutView()))
        ]),
        SettingItem(name: "Ring Settings", iconName: "bolt.fill",
        children: [
            SettingItem(name: "View My Ring Info", iconName: "info.circle.fill", view: AnyView(EmptyView())),
            SettingItem(name: "Change Bluetooth Settings", iconName: "personalhotspot", view: AnyView(EmptyView())),
            SettingItem(name: "Advanced Settings", iconName: "magnifyingglass.circle.fill", view: AnyView(EmptyView())),
            SettingItem(name: "Disconnect Ring", iconName: "x.circle.fill", destructive: true, view: AnyView(EmptyView()))
        ]),
        SettingItem(name: "Share data", iconName: "network", view: AnyView(
            BasicSettingView(title: "Send Data"){
                SendMyDataView()
            }
        )),
        SettingItem(name: "Appearance Settings", iconName: "eyedropper", view:
        AnyView(
            BasicSettingView(title: "Appearance Settings"){
                AppearanceSettings()
            }
        )),
        SettingItem(name: "Health App Sharing", iconName: "heart.fill", view: AnyView(EmptyView())),
        SettingItem(name: "Privacy Policy", iconName: "mail.and.text.magnifyingglass", url: URL(string: "https://www.termsfeed.com/live/54e40939-c377-4dad-83a3-ce7020bf2d70")!),
        SettingItem(name: "Contact Us", iconName: "phone.fill.arrow.down.left", sheet: AnyView(EmptyView())),
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
