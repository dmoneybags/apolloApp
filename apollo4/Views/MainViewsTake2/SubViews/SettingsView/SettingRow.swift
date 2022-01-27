//
//  SettingRow.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/22/22.
//

import SwiftUI

struct SettingRow: View {
    var setting: SettingItem
    var nestLevel: CGFloat = 1
    @State private var isFullscreen: Bool = false
    @State private var showAlert: Bool = false
    @State private var showSheet: Bool = false
    @State private var showingChildren: Bool = false
    @State private var childrenDidAppear: Bool = false
    @State private var mailData = ComposeMailData(subject: "",
                                                    recipients: ["customerservice@senecamedicaldevices.com"],
                                                    message: "",
                                                    attachments: [AttachmentData(data: "".data(using: .utf8)!,
                                                                                 mimeType: "text/plain",
                                                                                 fileName: "text.txt")
                                                   ])
    var body: some View {
        VStack{
            HStack{
                if setting.iconName != nil {
                    Image(systemName: setting.iconName!)
                        .padding(.leading, 15 * nestLevel)
                }
                Button{
                    if setting.view != nil && setting.alertTitle == nil{
                        print("SETTINGS::Showing view for \(setting.name)")
                        isFullscreen.toggle()
                    } else if setting.alertTitle != nil {
                        print("SETTINGS::Showing alert for \(setting.name)")
                        showAlert = true
                    } else if setting.url != nil {
                        UIApplication.shared.open(setting.url!)
                    } else if setting.sheet != nil {
                        print("SETTINGS::Showing sheet for \(setting.name)")
                        showSheet = true
                    }
                } label: {
                    Text(setting.name)
                        .foregroundColor(setting.color)
                        .padding(.leading, setting.iconName != nil ? 5 : 15 * nestLevel)
                }
                .allowsHitTesting(setting.children == nil)
                .disabled(setting.sheet == nil ? false : !MailView.canSendMail)
                Spacer()
                if setting.children != nil {
                    Image(systemName: "greaterthan.circle")
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: showingChildren ? 90.0 : 0.0))
                        .onTapGesture{
                            withAnimation(.spring()){
                                showingChildren.toggle()
                            }
                        }
                }
            }
            .frame(height: 30)
            .fullScreenCover(isPresented: $isFullscreen){
                setting.view!
            }
            .alert(setting.alertTitle ?? "ERROR this should not appear", isPresented: $showAlert){
                Button("Yes"){
                    setting.action!()
                    if setting.view != nil {
                        isFullscreen = true
                    }
                }
                Button("Cancel", role: .cancel){
                    
                }
            }
            .sheet(isPresented: $showSheet){
                MailView(data: $mailData) { result in
                        print(result)
                }
            }
            Divider()
            if showingChildren {
                VStack {
                    ForEach(setting.children!.indices, id: \.self){indice in
                        SettingRow(setting: setting.children![indice], nestLevel: nestLevel + 1)
                    }
                }
                .onAppear{
                    withAnimation(.easeInOut){
                        childrenDidAppear = true
                    }
                }
                .onDisappear(){
                    withAnimation(.easeInOut){
                        childrenDidAppear = false
                    }

                }
                .scaleEffect(x: 1, y: childrenDidAppear ? 1: 0.01, anchor: .top)
            }
        }
        
    }
}
