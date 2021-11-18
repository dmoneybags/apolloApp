//
//  UserData.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/4/21.
//

import Foundation
class UserData:  ObservableObject {
    private init() {}
    init(id: String) {
        self.id = id
        self.name = ""
        self.stage = 0
        self.isSignedIn = true
    }
    static let shared = UserData()
    private var id: String!
    private var name: String?
    private var firstName: String?
    private var lastName: String?
    private var birthday: Date?
    private var email: String?
    private var phoneNumber: String?
    var notify: Bool = true
    @Published var stage: Int!
    @Published var isSignedIn : Bool = false
    func getId() -> String {
        return self.id
    }
    func getName() -> String? {
        return self.name
    }
    func setName(inputName: String){
        self.name = inputName
    }
    func setId(inputId: String){
        self.id = inputId
    }
    func setFirstName(inputName: String){
        self.firstName = inputName
    }
    func getFirstName() -> String? {
        return self.firstName
    }
    func setLastName(inputName: String){
        self.lastName = inputName
    }
    func getLastName() -> String? {
        return self.lastName
    }
    func getBirthday() -> Date? {
        return self.birthday
    }
    func setBirthday(inputBirthday: Date){
        self.birthday = inputBirthday
    }
    func getEmail() -> String? {
        return self.email
    }
    func setEmail(inputEmail: String){
        self.email = inputEmail
    }
    func getPhoneNumber() -> String? {
        return self.phoneNumber
    }
    func setPhoneNumber(inputNumber: String){
        self.phoneNumber = inputNumber
    }
    func incrementStage() {
        self.stage = self.stage + 1
    }
    func decrementStage() {
        self.stage = self.stage - 1
    }
}
