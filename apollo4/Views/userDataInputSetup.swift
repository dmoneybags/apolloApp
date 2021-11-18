//
//  userDataInputSetup.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/8/21.
//

import SwiftUI
//import iPhoneNumberField

struct userDataInputSetup: View {
    @EnvironmentObject var user: UserData
    @State private var inputing = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var birthday: Date = Date()
    @State private var phoneNumber = ""
    @State private var notify = true
    var drag: some Gesture {
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width > 0 {
                        self.inputing = true
                    }
                })
        }
    var body: some View {
        VStack {
            if !inputing {
                VStack{
                    Text("Lets learn a little more about you")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Divider()
                        .padding(.horizontal, 17.0)
                    Image("setupImage2")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 270, height: 200)
                    swipeView()
                        .gesture(drag)
                }
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                .zIndex(1)
            } else {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading){
                            Text("First Name:")
                                .font(.callout)
                                .foregroundColor(Color.black)
                                .padding([.top, .leading])
                            TextField("Enter your first name", text: $firstName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 10.0)
                            Text("Last Name:")
                                .font(.callout)
                                .foregroundColor(Color.black)
                                .padding([.top, .leading])
                            TextField("Enter your last name", text: $lastName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 10.0)
                            Text("Email:")
                                .font(.callout)
                                .foregroundColor(Color.black)
                                .padding([.top, .leading])
                            TextField("Ex: Apollo@greece.com", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 10.0)
                            Text("Date of Birth:")
                                .font(.callout)
                                .foregroundColor(Color.black)
                                .padding([.top, .leading])
                            DatePicker("", selection: $birthday, displayedComponents: .date)
                                .frame(width: 80, height: 20, alignment: .leading)
                            Text("Phone Number:")
                                .font(.callout)
                                .foregroundColor(Color.black)
                                .padding([.top, .leading])
                            //iPhoneNumberField("1-800-000-0000", text: $phoneNumber)
                                //.padding(.leading, 15)
                        }
                        Toggle("Notify me via email", isOn: $notify)
                            .padding()
                    }
                    .padding([.leading, .trailing, .top], 15)
                    HStack {
                        Button(action: {user.decrementStage()}){
                            Image(systemName: "backward.fill")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.red)
                                .frame(width: 20)
                        }
                        
                        Button(action: {user.incrementStage()}){
                            Image(systemName: "forward.fill")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.blue)
                                .frame(width: 20)
                        }
                    }
                    .padding(.bottom, 5)
                }
            }
        }
        .frame(width: 300, height: 400, alignment: .center)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .shadow(radius: 5)
        .onDisappear(){
            user.setFirstName(inputName: firstName)
            user.setLastName(inputName: lastName)
            user.setEmail(inputEmail: email)
            user.setBirthday(inputBirthday: birthday)
            user.setPhoneNumber(inputNumber: phoneNumber)
            user.notify = notify
        }
    }
}

struct userDataInputSetup_Previews: PreviewProvider {
    static var previews: some View {
        userDataInputSetup()
    }
}
