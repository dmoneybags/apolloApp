//
//  BasicInfoContent.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/17/22.
//

import SwiftUI
import NotificationBannerSwift

class ObservableString: ObservableObject{
    @Published var str: String
    @Published var valid: Bool = true
    init(value: String){
        str = value
    }
}
struct VerifiedTextField: View{
    @ObservedObject var string: ObservableString
    var title: String
    var inputText: String? = nil
    var regEx: String? = nil
    @State private var touched: Bool = false
    @State private var passed: Bool = true
    var body: some View{
        HStack{
            Text(title + ":")
                .padding()
                .font(.title2)
            Spacer()
        }
        TextField(
            inputText ?? "Enter your " + title,
            text: $string.str
        )
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .padding(.horizontal)
        .onChange(of: string.str){value in
            if regEx != nil {
                passed = (value.range(of: regEx!, options: .regularExpression) != nil)
                if passed{
                    string.valid = true
                }
            }
        }
        .onSubmit {
            touched = true
        }
        if touched && (!passed || string.str.isEmpty){
            Text("Please enter a valid " + title)
                .foregroundColor(.red)
                .padding(.horizontal)
                .onAppear{
                    print("String validation failed")
                    string.valid = false
                }
        }
    }
}
struct BasicInfoContent: View {
    @ObservedObject var userData: UserData
    @ObservedObject var done: observableBool
    @State private var firstName: ObservableString = ObservableString(value: "")
    @State private var lastName: ObservableString = ObservableString(value: "")
    @State private var email: ObservableString = ObservableString(value: "")
    @State private var phoneNumber: ObservableString = ObservableString(value: "")
    @State private var birthday: Date = Date()
    private var isValid: Bool {
        return (firstName.valid) && (lastName.valid) && (email.valid) && (phoneNumber.valid)
    }
    private let successNotification = NotificationBanner(title: "Success", subtitle: "Data Saved", style: .success)
    private let errorNotification = NotificationBanner(title: "Failed", subtitle: "All fields are mandatory", style: .danger)
    var body: some View {
        ScrollView{
            VStack{
                VerifiedTextField(string: firstName, title: "First Name")
                VerifiedTextField(string: lastName, title: "Last Name")
                VerifiedTextField(string: email, title: "Email", regEx: #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#)
                VerifiedTextField(string: phoneNumber, title: "Phone Number", inputText: "1-234-456-7890", regEx: #"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$"#)
                VStack{
                    HStack{
                        Text("Enter your birthday:")
                            .padding()
                            .font(.title2)
                        Spacer()
                    }
                    DatePicker("born on:", selection: $birthday, displayedComponents: .date)
                        //.datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.horizontal, 30)
                }
            }
            .textFieldStyle(.roundedBorder)
        }
        .onChange(of: done.value){done in
            if done{
                finish()
            }
        }
        Spacer()
    }
    func finish(){
        if !firstName.str.isEmpty && !lastName.str.isEmpty && !email.str.isEmpty{
            print("WRITING BASIC DATA TO USER DATA")
            userData.setFirstName(inputName: firstName.str)
            userData.setLastName(inputName: lastName.str)
            userData.setEmail(inputEmail: email.str)
            userData.setPhoneNumber(inputNumber: phoneNumber.str)
            userData.setBirthday(inputBirthday: birthday)
            successNotification.show()
        } else {
            errorNotification.show()
            done.value = false
        }
    }
}
