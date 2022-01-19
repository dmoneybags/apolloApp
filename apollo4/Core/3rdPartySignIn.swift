//
//  SignInWithGoogle.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/18/22.
//
import AWSMobileClient
import Amplify
import Combine
import Foundation
//V1 now deprecated
func signInWithThirdParty(party: String) {
    let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email", "profile"], identityProvider: party)

    AWSMobileClient.default().showSignIn(presentationAnchor: UIApplication.shared.windows.first!, hostedUIOptions: hostedUIOptions) { (userState, error) in
        if let error = error as? AWSMobileClientError {
            print(error.localizedDescription)
        }
        if let userState = userState {
            print("Status: \(userState.rawValue)")
            
            AWSMobileClient.default().getTokens { (tokens, error) in
                if let error = error {
                    print("error \(error)")
                } else if let tokens = tokens {
                    let claims = tokens.idToken?.claims
                    print("username? \(claims?["username"] as? String ?? "No username")")
                    print("cognito:username? \(claims?["cognito:username"] as? String ?? "No cognito:username")")
                    print("email? \(claims?["email"] as? String ?? "No email")")
                    print("name? \(claims?["name"] as? String ?? "No name")")
                    print("picture? \(claims?["picture"] as? String ?? "No picture")")
                }
            }
        }
        
    }
}
func socialSignInWithWebUI(for provider: AuthProvider) -> AnyCancellable {
    Amplify.Auth.signInWithWebUI(for: provider, presentationAnchor: UIApplication.shared.windows.first!)
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Sign in failed \(authError)")
            }
        }
        receiveValue: { userData in
            print(userData)
            print("Sign in succeeded")
        }
}
