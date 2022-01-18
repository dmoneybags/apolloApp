//
//  AggregateSetupView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/18/22.
//

import SwiftUI

enum SetupViewTypes{
    case basic
    case bp
    case signin
}

struct AggregateSetupView: View {
    @State private var userData: UserData = UserData(id: UUID().uuidString)
    //Which one are we on?
    @State private var selector = 0
    @State private var offsetX: CGFloat = 0.0
    @State private var viewDeque: [SetupViewTypes] = [.signin, .bp, .basic]
    @State private var switchedViews: Bool = false
    private let width = UIScreen.main.bounds.width
    var body: some View {
        ZStack{
            BasicSetupView(userData: userData, title: "Sign up", color: Color(hexString: "0F8A00")){
                SignInView(userData: userData)
            }
            .zIndex(Double(viewDeque.firstIndex(of: .signin)!))
            .rotationEffect(viewDeque.last == .signin ? Angle(degrees: Double(offsetX/width) *  30.0) : Angle(degrees: 0))
            .offset(x: viewDeque.last == .signin ? offsetX : 0, y: 0)
            BasicSetupView(userData: userData, title: "Blood Pressure Info", color: .pink){
                BPInfo(userData: userData)
            }
            .zIndex(Double(viewDeque.firstIndex(of: .bp)!))
            .rotationEffect(viewDeque.last == .bp ? Angle(degrees: Double(offsetX/width) *  30.0) : Angle(degrees: 0))
            .offset(x: viewDeque.last == .bp ? offsetX : 0, y: 0)
            BasicSetupView(userData: userData, title: "Basic Information", color: .blue){
                BasicInfoContent(userData: userData)
            }
            .zIndex(Double(viewDeque.firstIndex(of: .basic)!))
            .rotationEffect(viewDeque.last == .basic ? Angle(degrees: Double(offsetX/width) *  30.0) : Angle(degrees: 0))
            .offset(x: viewDeque.last == .basic ? offsetX : 0, y: 0)
        }
        .gesture(
            DragGesture()
                .onChanged{value in
                    if !(value.translation.width > 0 && viewDeque.last == .basic) && !(value.translation.width < 0 && viewDeque.last == .signin){
                        if value.translation.width > 0{
                            if !switchedViews{
                                viewDeque.swapAt(1, 0)
                                switchedViews.toggle()
                            }
                        } else {
                            if switchedViews{
                                viewDeque.swapAt(1, 0)
                                switchedViews.toggle()
                            }
                        }
                        offsetX = value.translation.width
                    }
                }
                .onEnded{value in
                    if switchedViews{
                        viewDeque.swapAt(1, 0)
                        switchedViews = false
                    }
                    if value.translation.width > 50 {
                        swipeRight()
                        offsetX = 0
                    } else if value.translation.width < -50{
                        swipeLeft()
                        offsetX = 0
                    } else {
                        offsetX = 0
                    }
                }
        )
    }
    private func swipeLeft(){
        if viewDeque.last != .signin {
            let lastElement = viewDeque.popLast()
            viewDeque.insert(lastElement!, at: 0)
        }
    }
    private func swipeRight(){
        if viewDeque.last != .basic{
            let firstElement = viewDeque.removeFirst()
            viewDeque.append(firstElement)
        }
    }
}

struct AggregateSetupView_Previews: PreviewProvider {
    static var previews: some View {
        AggregateSetupView().preferredColorScheme(.dark)
    }
}
