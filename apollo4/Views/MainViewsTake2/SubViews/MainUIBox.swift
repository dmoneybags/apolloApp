//
//  MainUIBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//

import SwiftUI

struct MainUIBox<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var animatorVal : Double = 0.7
    var statObject : StatDataObject
    var imageName : String
    var foregroundColor : Color?
    var cardFunc : (Int) -> AnyView
    var numCards : Int
    @ViewBuilder var content: Content
    var body: some View {
        VStack{
            HStack{
                Text(statObject.name ?? "Unknown")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
                Spacer()
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(foregroundColor ?? Color.white)
                    .padding(.top)
                    .padding(.horizontal)
                    .scaleEffect(imageName == "heart.fill" ? animatorVal : 1.0)
                    .onAppear(){
                        withAnimation(Animation.easeInOut(duration: 60.0/(statObject.data.last as! Double)).repeatForever()){
                            animatorVal = 1.0
                        }
                    }
                Text(String(statObject.data.last as! Int))
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.trailing)
            }
            Divider()
                .padding(.horizontal)
                .padding(.top,  -10)
            MainUIBoxScroller(width: UIScreen.main.bounds.size.width - 20, statDataObject: statObject){
                content
            }
            Divider()
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<numCards, id: \.self){Card in
                        GeometryReader {geometry in
                            cardFunc(Card)
                                .padding()
                                .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX) - 40) / -20, axis: (x: 0, y: 10.0, z: 0))
                        }
                        .frame(width: 150)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.size.width - 60, height: 250, alignment: .center)
            Divider()
            HStack {
                Text("See more general data...")
                    .padding()
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 20, alignment: .center)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(15.0)
        .padding(.leading, 10.0)
    }
}


