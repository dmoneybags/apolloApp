//
//  ProfileView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/22/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userData: UserData = .shared
    var body: some View {
        VStack{
            HStack{
                Text("First Name:")
                    .font(.title3)
                    .padding(.horizontal)
                Spacer()
            }
            HStack{
                Text(userData.getFirstName()!)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.leading)
                Spacer()
            }
            .padding(10)
            HStack{
                Text("Last Name:")
                    .font(.title3)
                    .padding(.horizontal)
                Spacer()
            }
            HStack{
                Text(userData.getLastName()!)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.leading)
                Spacer()
            }
            .padding(10)
            HStack{
                Text("Birthday:")
                    .font(.title3)
                    .padding(.horizontal)
                Spacer()
            }
            HStack{
                Text("")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.leading)
                Spacer()
            }
            .padding(10)
        }
        .foregroundColor(Color(UIColor.systemGray))
    }
    
}
