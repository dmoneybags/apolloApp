// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "34d97e08b2d30f03be138b88a3097126"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: userDataModel.self)
  }
}