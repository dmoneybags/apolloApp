// swiftlint:disable all
import Amplify
import Foundation

public struct userDataModel: Model {
  public let id: String
  public var firstName: String
  public var lastName: String
  public var birthday: Int
  public var email: String
  public var phoneNumber: String
  public var systolic: Int
  public var diastolic: Int
  public var isSignedIn: Bool
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      firstName: String,
      lastName: String,
      birthday: Int,
      email: String,
      phoneNumber: String,
      systolic: Int,
      diastolic: Int,
      isSignedIn: Bool) {
    self.init(id: id,
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
      email: email,
      phoneNumber: phoneNumber,
      systolic: systolic,
      diastolic: diastolic,
      isSignedIn: isSignedIn,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      firstName: String,
      lastName: String,
      birthday: Int,
      email: String,
      phoneNumber: String,
      systolic: Int,
      diastolic: Int,
      isSignedIn: Bool,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.firstName = firstName
      self.lastName = lastName
      self.birthday = birthday
      self.email = email
      self.phoneNumber = phoneNumber
      self.systolic = systolic
      self.diastolic = diastolic
      self.isSignedIn = isSignedIn
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}

func teser(){
    print("fa")
}
