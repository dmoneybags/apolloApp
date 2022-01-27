//
//  healthSetupView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import SwiftUI

struct healthSetupView: View {
    @EnvironmentObject var user: UserData
    @ObservedObject var bpm = TextLimiter(limit: 3)
    @ObservedObject var sys = TextLimiter(limit: 3)
    @ObservedObject var dia = TextLimiter(limit: 3)
    @ObservedObject var age = TextLimiter(limit: 3)
    @State private var inputing = false
    @State private var ecgpumped: Bool = false
    @State private var showLive: Bool = false
    @State private var gender = "Please pick one"
    private var genders = ["Male", "Female", "Prefer not to say"]
    var drag: some Gesture {
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width > 0 {
                        self.inputing = true
                    }
                })
        }
    var body: some View {
        ZStack {
            VStack {
                if !inputing {
                    VStack{
                        Text("Build a health profile")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Divider()
                        Text("Giving background knowledge on your vitals helps calibrate the device and provide insights")
                            .font(.footnote)
                            .foregroundColor(Color(UIColor.systemGray))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Image("healthImage")
                            .resizable()
                            .frame(width: 150, height: 150)
                        swipeView()
                            .gesture(drag)
                    }
                } else {
                    VStack {
                        ScrollView {
                            Text("Average resting heart rate")
                            Divider()
                            ZStack {
                                TextField("", text: $bpm.value)
                                    .keyboardType(.numberPad)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .textFieldStyle(.roundedBorder)
                                    .border(Color.red, width: $bpm.hasReachedLimit.wrappedValue ? 1 : 0 )
                                    .padding()
                                VStack{
                                    HStack {
                                        Image(systemName: "waveform.path.ecg")
                                            .foregroundColor(Color.red)
                                            .scaleEffect(CGSize(width: 1.0, height: ecgpumped ? 1.0: -1.0))
                                            .onTapGesture {
                                                showLive = true
                                            }
                                            .onAppear(){
                                                withAnimation(Animation.easeInOut(duration: 2).repeatForever(), {
                                                    self.ecgpumped.toggle()
                                                    })
                                        }
                                        .padding(.all, 2)
                                    }
                                    .background(Circle().fill(Color.white))
                                }
                                .position(x: 250, y: 34)
                            }
                            Text("Blood pressure")
                            Divider()
                            HStack{
                                TextField("", text: $sys.value)
                                    .keyboardType(.numberPad)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .textFieldStyle(.roundedBorder)
                                    .border(Color.red, width: $sys.hasReachedLimit.wrappedValue ? 1 : 0 )
                                .padding()
                                Text("/")
                                TextField("", text: $dia.value)
                                    .keyboardType(.numberPad)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .textFieldStyle(.roundedBorder)
                                    .border(Color.red, width: $dia.hasReachedLimit.wrappedValue ? 1 : 0 )
                                .padding()
                            }
                            Text("Gender")
                            Divider()
                            VStack {
                                Picker("Please choose one", selection: $gender){
                                    ForEach(genders, id: \.self){
                                        Text($0)
                                    }
                                }
                                Text("Age")
                                Divider()
                                TextField("", text: $age.value)
                                    .keyboardType(.numberPad)
                                    .frame(width: 60, height: 30, alignment: .center)
                                    .textFieldStyle(.roundedBorder)
                                    .border(Color.red, width: $age.hasReachedLimit.wrappedValue ? 1 : 0 )
                                    .padding()
                            }
                        }
                        .padding()
                        HStack {
                            Button(action: {user.decrementStage()}){
                                Image(systemName: "backward.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.red)
                                    .frame(width: 20)
                            }
                            
                            Button(action: {user.incrementStage()}){
                                Image(systemName: "forward.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 20)
                            }
                        }
                        .padding(.bottom, 5)
                    }
                }
            }
            .frame(width: 300, height: 400, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            .shadow(radius: 5)
            if showLive {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .position(x: 50, y: 50)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        showLive = false
                    }
                    
            }
        }
    }
}

struct healthSetupView_Previews: PreviewProvider {
    static var previews: some View {
        healthSetupView()
    }
}
