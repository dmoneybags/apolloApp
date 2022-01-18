//
//  Backend.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/4/21.
//

import Foundation
import UIKit
import Amplify
import AmplifyPlugins
import AWSMobileClient
class Backend {
    static let shared = Backend()
    
    static func initialize() -> Backend {
        return .shared
    }
    private init() {
      // initialize amplify
      do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
        try Amplify.configure()
        initializeAWSMobileClient()
        print("Initialized Amplify");
      } catch {
        print("Could not initialize Amplify: \(error)")
      }
        _ = Amplify.Hub.listen(to: .auth) { (payload) in

            switch payload.eventName {

            case HubPayload.EventName.Auth.signedIn:
                print("==HUB== User signed In, update UI")
                self.updateUserData(withSignInStatus: true)

            case HubPayload.EventName.Auth.signedOut:
                print("==HUB== User signed Out, update UI")
                self.updateUserData(withSignInStatus: false)

            case HubPayload.EventName.Auth.sessionExpired:
                print("==HUB== Session expired, show sign in UI")
                self.updateUserData(withSignInStatus: false)

            default:
                //print("==HUB== \(payload)")
                break
            }
        }
         
        // let's check if user is signedIn or not
         _ = Amplify.Auth.fetchAuthSession { (result) in
             do {
                 let session = try result.get()
                        
        // let's update UserData and the UI
             self.updateUserData(withSignInStatus: session.isSignedIn)
                        
             } catch {
                  print("Fetch auth session failed with error - \(error)")
            }
        }    
    }
    func initializeAWSMobileClient(){
        AWSMobileClient.default().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
            }
        }
     }
    public func signIn() {

        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: UIApplication.shared.windows.first!) { result in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Authorization"), object: 0)
                print("Sign in succeeded")
            case .failure(let error):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Authorization"), object: 1)
                print("Sign in failed \(error)")
            }
        }
    }

    // signout
    public func signOut() {
        _ = Amplify.Auth.signOut() { (result) in
            switch result {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Authorization"), object: 0)
                print("Successfully signed out")
            case .failure(let error):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Authorization"), object: 1)
                print("Sign out failed with error \(error)")
            }
        }
    }
    public func reauth() {
        signOut()
        signIn()
    }
    public func getUser() -> String? {
        return Amplify.Auth.getCurrentUser()?.userId
    }
    // change our internal state, this triggers an UI update on the main thread
    func updateUserData(withSignInStatus status : Bool) {
        DispatchQueue.main.async() {
            let userData : UserData = .shared
            userData.isSignedIn = status
        }
    }
    func createUser(user: UserData) {
        let userDataModelInstance : userDataModel = userDataModel(name: user.getName() != nil ? user.getName()! : "Apollo")
        print(userDataModelInstance)
        _ = Amplify.API.mutate(request: .create(userDataModelInstance)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let data):
                    print("Successfully created user: \(data)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
            }
        }
    }
}
