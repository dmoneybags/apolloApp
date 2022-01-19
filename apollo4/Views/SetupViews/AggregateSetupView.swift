//
//  AggregateSetupView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/18/22.
//

import SwiftUI
import Amplify

enum SetupViewTypes{
    case basic
    case bp
    case signin
}

struct AggregateSetupView: View {
    @ObservedObject var userData: UserData
    //Which one are we on?
    @State private var selector = 0
    @State private var offsetX: CGFloat = 0.0
    @State private var viewDeque: [SetupViewTypes] = [.signin, .bp, .basic]
    @State private var switchedViews: Bool = false
    @State private var moving: Bool = false
    @State private var basicDone: observableBool = observableBool(value: false)
    @State private var bpDone: observableBool = observableBool(value: false)
    private let width = UIScreen.main.bounds.width
    var body: some View {
        ZStack(alignment: .top){
            Image("logowhttrans")
                .resizable()
                .frame(width: 80, height: 40, alignment: .center)
                .padding(25)
                .ignoresSafeArea(edges: .top)
                .zIndex(4)
            SetupViewTutorial()
                .zIndex(10)
            BasicSetupView(userData: userData, title: "Sign up", color: Color(hexString: "0F8A00"), showSwipe: false){
                SignInView(userData: userData, basicDone: basicDone, bpDone: bpDone)
            }
            .zIndex(Double(viewDeque.firstIndex(of: .signin)!))
            .rotationEffect(viewDeque.last == .signin ? Angle(degrees: Double(offsetX/width) *  30.0) : Angle(degrees: 0))
            .offset(x: viewDeque.last == .signin ? offsetX : 0, y: 0)
            BasicSetupView(userData: userData, title: "Blood Pressure Info", color: .pink){
                BPInfo(userData: userData, bpDone: bpDone)
            }
            .zIndex(Double(viewDeque.firstIndex(of: .bp)!))
            .rotationEffect(viewDeque.last == .bp ? Angle(degrees: Double(offsetX/width) *  30.0) : Angle(degrees: 0))
            .offset(x: viewDeque.last == .bp ? offsetX : 0, y: 0)
            BasicSetupView(userData: userData, title: "Basic Information", color: .blue){
                BasicInfoContent(userData: userData, done: basicDone)
            }
            .zIndex(Double(viewDeque.firstIndex(of: .basic)!))
            .rotationEffect(viewDeque.last == .basic ? Angle(degrees: Double(offsetX/width) *  30.0) : Angle(degrees: 0))
            .offset(x: viewDeque.last == .basic ? offsetX : 0, y: 0)
        }
        .gesture(
            DragGesture()
                .onChanged{value in
                    if !(value.translation.width > 0 && viewDeque.last == .basic) && !(value.translation.width < 0 && viewDeque.last == .signin){
                        if (value.translation.width > 20 || value.translation.width < -20) || moving{
                            moving = true
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
                }
                .onEnded{value in
                    moving = false
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
            if viewDeque.last == .basic{
                basicDone.value = true
            }
            if viewDeque.last == .bp {
                bpDone.value = true
            }
            let lastElement = viewDeque.popLast()
            viewDeque.insert(lastElement!, at: 0)
            print(userData.description)
            print(basicDone.value ? "BASIC INFO FINISHED" : "BASIC INFO NOT FINISHED")
            print(bpDone.value ? "BP INFO FINISHED" : "BP INFO NOT FINISHED")
        }
    }
    private func swipeRight(){
        if viewDeque.last != .basic{
            let firstElement = viewDeque.removeFirst()
            viewDeque.append(firstElement)
            print(userData.description)
            if viewDeque.last == .basic{
                basicDone.value = false
            }
            if viewDeque.last == .bp {
                basicDone.value = false
            }
        }
    }
}


