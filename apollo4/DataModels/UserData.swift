//
//  UserData.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/4/21.
//

import Foundation
class UserData:  ObservableObject {
    init() {}
    init(id: String) {
        self.id = id
        self.name = ""
        self.stage = 0
        self.isSignedIn = false
    }
    init(userDataModel: Userdatamodel){
        self.id = userDataModel.id
        self.firstName = userDataModel.firstName
        self.lastName = userDataModel.lastName
        self.birthday = Date(timeIntervalSince1970: TimeInterval(userDataModel.birthday!))
        self.email = userDataModel.email
        self.phoneNumber = userDataModel.phoneNumber
        self.systolicCalibData = userDataModel.systolic
        self.diastolicCalibData = userDataModel.diastolic
        self.isSignedIn = userDataModel.isSignedIn ?? true
    }
    static var shared = UserData()
    private var id: String!
    private var name: String?
    private var firstName: String?
    private var lastName: String?
    private var birthday: Date?
    private var email: String?
    private var phoneNumber: String?
    var systolicCalibData: Int?
    var diastolicCalibData: Int?
    var notify: Bool = true
    @Published var stage: Int!
    @Published var isSignedIn : Bool = false
    public var description: String {return "\(Date()) Userdata object {\n id: \(String(describing: id)) \n name: \(String(describing: name)) \n firstName: \(String(describing: firstName)) \n lastName: \(lastName) \n birthday: \(birthday) \n email: \(email) \n phoneNumber: \(phoneNumber) \n systolic: \(systolicCalibData) \n diastolic: \(String(describing: diastolicCalibData)) \n isSignedIn: \(isSignedIn) \n  }"}
    func getId() -> String? {
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
