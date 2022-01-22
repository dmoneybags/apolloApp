// swiftlint:disable all
import Amplify
import Foundation

extension userDataModel {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case firstName
    case lastName
    case birthday
    case email
    case phoneNumber
    case systolic
    case diastolic
    case isSignedIn
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userDataModel = userDataModel.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "userDataModels"
    
    model.fields(
      .id(),
      .field(userDataModel.firstName, is: .required, ofType: .string),
      .field(userDataModel.lastName, is: .required, ofType: .string),
      .field(userDataModel.birthday, is: .required, ofType: .int),
      .field(userDataModel.email, is: .required, ofType: .string),
      .field(userDataModel.phoneNumber, is: .required, ofType: .string),
      .field(userDataModel.systolic, is: .required, ofType: .int),
      .field(userDataModel.diastolic, is: .required, ofType: .int),
      .field(userDataModel.isSignedIn, is: .required, ofType: .bool),
      .field(userDataModel.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userDataModel.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
