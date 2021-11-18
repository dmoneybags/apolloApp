//
//  nameSetup.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/7/21.
//

import SwiftUI

struct nameSetup: View {
    @EnvironmentObject var user: UserData
    @ObservedObject var kGuardian: KeyboardGuardian = KeyboardGuardian(textFieldCount: 1)
    @State var username: String = ""
    var body: some View {
        VStack {
            Text("Lets start with a name for the ring")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            ZStack {
                Image("nameImage")
                    .resizable()
                    .clipShape(Circle())
            }
            .frame(width: 300, height: 200, alignment: .center)
            TextField("\"My ring name\"", text: $username, onEditingChanged: { if $0 { self.kGuardian.showField = 0 } })
                                    .padding(.all, 5.0)
                                    .frame(width: 250.0)
                                    .foregroundColor(Color.white)
                                    .background(Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .cornerRadius(5)
                                    .padding(.top, 15.0)
                                    .background(GeometryGetter(rect: $kGuardian.rects[0]))
            if username != "" {
                Button(action: {user.incrementStage()}){
                    Image(systemName: "forward.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.blue)
                        .frame(width: 20)
                }
            } else {
                Text("")
                    .frame(width: 20, height: 12)
            }
        }
        .onAppear { self.kGuardian.addObserver() }
        .frame(width: 300, height: 400, alignment: .center)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .shadow(radius: 5)
        .offset(y: kGuardian.slide).animation(.easeInOut(duration: 1.0))
        .onDisappear(){
            self.kGuardian.removeObserver()
            user.setName(inputName: username)
        }
    }
}

struct nameSetup_Previews: PreviewProvider {
    static var previews: some View {
        nameSetup()
    }
}
