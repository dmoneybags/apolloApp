//
//  ProfileView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/22/22.
//

import SwiftUI

struct BasicSettingView<Content: View>: View  {
    
    var title: String
    @ViewBuilder var content: Content
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .rotationEffect(Angle(degrees: 270))
                        .scaleEffect(1.5)
                }
                Spacer()
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.trailing, 15)
                Spacer()
            }
            .padding()
            Divider()
            content
            Spacer()
        }
    }
}

struct BasicSettingView_Previews: PreviewProvider {
    static var previews: some View {
        BasicSettingView(title: "My Account"){
            Text("Hey")
        }
        .preferredColorScheme(.dark)
    }
}
