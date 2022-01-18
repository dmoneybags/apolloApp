//
//  SignInView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/17/22.
//

import SwiftUI

struct SignInButton: View {
    var body: some View {
        Button(action: { Backend.shared.signIn() }){
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(.trailing,5)
                Spacer()
                Text("Create Account")
                    .font(.footnote)
                    .padding(.trailing, 20)
                Spacer()
            }
            .frame(width: 200, height: 20)
            .padding(.horizontal,10)
            .padding(.vertical,5)
            .foregroundColor(.white)
            .background(Color(hexString: "0F8A00"))
            .cornerRadius(30)
        }
    }
}
struct GoogleSignInButton: View {
    var body: some View  {
        Button(action: {
            print("signing in with google")
            let _ = socialSignInWithWebUI(for: .google)
        }){
            HStack{
                HStack {
                    Image("googleLogo")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.trailing,5)
                    Spacer()
                    Text("Sign up with Google")
                        .font(.footnote)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .frame(width: 200, height: 20)
                .padding(.horizontal,10)
                .padding(.vertical,5)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(30)
            }
        }
    }
}
struct AppleSignInButton: View {
    var body: some View {
        Button(action: {
            print("signing in with apple")
            let _ = socialSignInWithWebUI(for: .apple)
        }){
            HStack{
                HStack {
                    Image(systemName: "applelogo")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.trailing,5)
                    Spacer()
                    Text("Sign up with Apple")
                        .font(.footnote)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .frame(width: 200, height: 20)
                .padding(.horizontal,10)
                .padding(.vertical,5)
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(30)
            }
        }
    }
}
struct FbSignInButton: View {
    var body: some View {
        Button(action: {
            print("signing in with google")
            let _ = socialSignInWithWebUI(for: .facebook)
        }){
            HStack{
                HStack {
                    Image("facebookLogo")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.trailing,5)
                    Spacer()
                    Text("Sign up with Facebook")
                        .font(.footnote)
                        .font(.callout)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .frame(width: 200, height: 20)
                .padding(.horizontal,10)
                .padding(.vertical,5)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(30)
            }
        }
    }
}
struct SignInView: View {
    @ObservedObject var userData: UserData
    var body: some View {
        Text("A method of authentification is needed to associate you with your data in the case that you switch phones or get a new ring. We recommend signing in with a third party provider (Apple, Facebook, Google). However you can sign up directly with us.")
            .font(.footnote)
            .padding()
            .minimumScaleFactor(500)
        Divider()
        SignInButton()
            .padding()
            .padding(.bottom, 15)
        GoogleSignInButton()
            .padding(5)
        AppleSignInButton()
            .padding(5)
        FbSignInButton()
            .padding(5)
    }
}
