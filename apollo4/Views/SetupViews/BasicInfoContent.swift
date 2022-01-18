//
//  BasicInfoContent.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/17/22.
//

import SwiftUI
class ObservableString: ObservableObject{
    @Published var str: String
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
        .onSubmit {
            if regEx != nil{
                passed = string.str.range(of: regEx!) != nil
            }
            withAnimation{
                touched = true
            }
        }
        if touched && (!passed || string.str.isEmpty){
            Text("Please enter a valid " + title)
                .foregroundColor(.red)
                .padding(.horizontal)
        }
    }
}
struct BasicInfoContent: View {
    @ObservedObject var userData: UserData
    @State private var firstName: ObservableString = ObservableString(value: "")
    @State private var lastName: ObservableString = ObservableString(value: "")
    @State private var email: ObservableString = ObservableString(value: "")
    @State private var phoneNumber: ObservableString = ObservableString(value: "")
    @State private var birthday: Date = Date()
    var body: some View {
        ScrollView{
            VStack{
                VerifiedTextField(string: firstName, title: "First Name")
                VerifiedTextField(string: lastName, title: "Last Name")
                VerifiedTextField(string: email, title: "Email", regEx: #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#)
                VerifiedTextField(string: phoneNumber, title: "Phone Number", inputText: "1-234-456-7890", regEx: #"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$"#)
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
    }
}

struct BasicInfoContent_Previews: PreviewProvider {
    static var previews: some View {
        BasicSetupView(userData: UserData(id: "13u9518958195810950195"), title: "Basic Information", color: .blue){
            BasicInfoContent(userData: UserData(id: "13u9518958195810950195")).preferredColorScheme(.dark)
        }
    }
}
