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
    @State private var showingChildren: Bool = false
    @State private var childrenDidAppear: Bool = false
    var body: some View {
        VStack{
            HStack{
                if setting.iconName != nil {
                    Image(systemName: setting.iconName!)
                        .padding(.leading, 15 * nestLevel)
                }
                Text(setting.name)
                    .foregroundColor(setting.color)
                    .padding(.leading, setting.iconName != nil ? 5 : 15 * nestLevel)
                Spacer()
                if setting.children != nil {
                    Image(systemName: "greaterthan.circle")
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: showingChildren ? 90.0 : 0.0))
                        .onTapGesture{
                            withAnimation(.spring()){
                                showingChildren.toggle()
                                if childrenDidAppear {
                                    childrenDidAppear = false
                                }
                            }
                        }
                }
            }
            .frame(height: 30)
            .onTapGesture{
                if setting.view != nil{
                    isFullscreen.toggle()
                }
            }
            .fullScreenCover(isPresented: $isFullscreen){
                setting.view!
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
                .scaleEffect(x: 1, y: childrenDidAppear ? 1: 0.01, anchor: .top)
            }
        }
    }
}
