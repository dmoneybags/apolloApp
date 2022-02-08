//
//  ContentView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/4/21.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    //Get colorscheme so we know if we have to change colors
    @Environment(\.colorScheme) var colorScheme
    //for loading stats
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    @ObservedObject var bleManager: BLEManager = .shared
    @ObservedObject var user: UserData = .shared
    @State private var numBarsANIMATION: CGFloat = 1.25
    @State private var opacityANIMATION: CGFloat = 0.0
    @State private var repeated = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    @State private var loadAccount = false
    @State private var loadSetup = false
    @State private var loadLogin = false
    @State private var loadDemo = false
    var body: some View {
        //Main top level view for whole app
        NavigationView {
            VStack {
                HStack {
                    Image(colorScheme == .dark ? "logowhttrans":"logo_white_background")
                        .resizable()
                        .frame(width: 100, height: 50, alignment: .center)
                }
                .frame(width: 100, height: 30)
                Divider()
                    .padding(.horizontal, 27.0)
                    .padding(.bottom, 5)
                //if we don't have a ring show pairing view
                if bleManager.connectedPeripheral == nil {
                    Text("Place ring close to device and pair by pressing the button below.")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.systemGray))
                        .multilineTextAlignment(.center)
                    .padding(.horizontal, 10.0)
                } else {
                    Text("Ring found!")
                        .font(.title)
                        .foregroundColor(Color.gray)
                        .opacity(opacityANIMATION)
                        .onAppear {
                            print("ring paired")
                            DispatchQueue.main.async {
                                withAnimation(repeated){
                                    opacityANIMATION = 1.0
                                }
                            }
                        }
                }
                HStack {
                    SceneView(
                        scene: {
                            let scene = SCNScene(named: "Apollo 1 Ring.obj")!
                            scene.background.contents = colorScheme == .dark ? UIColor.black : UIColor.white
                            return scene
                        }(),
                        options: [.autoenablesDefaultLighting,.allowsCameraControl])
                        .scaleEffect(0.6)
                        .frame(width: UIScreen.main.bounds.height/2.5, height: UIScreen.main.bounds.height/2.5)
                }
                ZStack {
                    if bleManager.connectedPeripheral == nil {
                        VStack{
                            Button(action: {
                                print("SCANNING")
                                _ = bleManager.startScanning()
                                //set id
                                }){
                                Image(systemName: "wifi")
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .scaleEffect(numBarsANIMATION)
                                }
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color.black))
                                .onAppear {
                                    DispatchQueue.main.async {
                                        withAnimation(repeated){
                                            numBarsANIMATION = 1.5
                                        }
                                    }
                                }
                            Button(action: loadDemoView){
                                Text("Demo")
                                    .transition(.opacity)
                            }
                        }
                    } else {
                        if user.isSignedIn {
                            Button(action: loadSetupView){
                                Text("Setup ring")
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.black))
                                    .transition(.opacity)
                                }
                        } else {
                            VStack(spacing: 10){
                                Button(action: loadLoginView){
                                    Text("Log In")
                                        .transition(.opacity)
                                    }
                                Button(action: loadAccountView){
                                    Text("Create Account")
                                        .transition(.opacity)
                                    }
                            }
                        }
                    }
                }
                .frame(width: 400, height: 80)
            }
            .onAppear{
                if stats.isEmpty {
                    print("GENERATING STATS")
                    _ = StatDataObject(inputName: "SPO2", context: moc, empty: true)
                    _ = StatDataObject(inputName: "HeartRate", context: moc, empty: true)
                    _ = StatDataObject(inputName: "SystolicPressure", context: moc, empty: true)
                    _ = StatDataObject(inputName: "DiastolicPressure", context: moc, empty: true)
                    _ = StatDataObject(inputName: "HrVar", context: moc, empty: true)
                    try? moc.save()
                }
            }
        }
        .environmentObject(bleManager)
        .fullScreenCover(isPresented: $loadAccount){
            AggregateSetupView(userData: user)
        }
        .fullScreenCover(isPresented: $loadSetup){
            RingSetup()
                .environmentObject(bleManager)
        }
        .fullScreenCover(isPresented: $loadLogin){
            BasicSetupView(userData: UserData.shared, title: "Log in", color: .purple){
                SignInView(userData: UserData.shared, basicDone: observableBool(value: true), bpDone: observableBool(value: true), isLogin: true)
            }
        }
        .fullScreenCover(isPresented: $loadDemo){
            MainView2()
        }
    }
    private func loadSetupView(){
        loadSetup = true
    }
    private func loadAccountView(){
        loadAccount = true
    }
    private func loadLoginView(){
        loadLogin = true
    }
    private func loadDemoView(){
        writeAllStats(num: 2000)
        loadDemo = true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
