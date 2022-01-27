//
//  ProfileView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/22/22.
//

import SwiftUI
import NotificationBannerSwift

struct ProfileView: View {
    @ObservedObject private var userData: UserData = .shared
    @State private var birthday = Date()
    @State private var email = ObservableString(value: "")
    @State private var phoneNumber = ObservableString(value: "")
    @State private var changed = false
    private let errorNotification = NotificationBanner(title: "Error", subtitle: "One or more fields is invalid", style: .danger)
    private let successNotification = NotificationBanner(title: "Success!", subtitle: "Data updated", style: .success)
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    Text("First Name:")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack{
                    Text(UserData.shared.getFirstName() ?? "Unknown")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                }
                .padding(10)
                HStack{
                    Text("Last Name:")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack{
                    Text(UserData.shared.getLastName() ?? "Unknown")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                }
                .padding(10)
                HStack{
                    Text("Birthday:")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack{
                    DatePicker("", selection: $birthday, displayedComponents: .date)
                        .labelsHidden()
                        .allowsHitTesting(false)
                        //.datePickerStyle(GraphicalDatePickerStyle())
                    Spacer()
                }
                .padding(10)
                HStack{
                    Text("Email:")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack{
                    VerifiedTextField(string: email, title: "", regEx: #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#, showTitle: false)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .onTapGesture{
                            changed = true
                        }
                    Spacer()
                }
                .padding(10)
                HStack{
                    Text("Phone Number ")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack{
                    VerifiedTextField(string: phoneNumber, title: "Phone Number", inputText: "1-234-456-7890", regEx: #"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$"#, showTitle: false)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .onTapGesture{
                            changed = true
                        }
                    Spacer()
                }
                .padding(10)
            }
            .foregroundColor(Color(UIColor.systemGray))
            .onAppear{
                print("Showing account info for \(userData.description)")
            }
            if changed {
                Button {
                    if phoneNumber.valid && email.valid {
                        Backend.shared.updateUser(withNumber: phoneNumber.str, withEmail: email.str)
                        successNotification.show()
                    } else {
                        errorNotification.show()
                    }
                } label: {
                    Text("Save")
                }
            }
        }
        .onAppear{
            birthday = UserData.shared.getBirthday() ?? Date()
            email = ObservableString(value: UserData.shared.getEmail() ?? "Unknown")
            phoneNumber = ObservableString(value: UserData.shared.getPhoneNumber() ?? "Unknown")
        }

    }
    func getBirthdayStr() -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: userData.getBirthday() ?? Date())
    }
}
