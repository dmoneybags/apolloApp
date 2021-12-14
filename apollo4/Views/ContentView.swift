//
//  ContentView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/4/21.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    @StateObject var bleManager: BLEManager = BLEManager()
    @StateObject var user: UserData = .shared
    @State private var numBarsANIMATION: CGFloat = 1.25
    @State private var opacityANIMATION: CGFloat = 0.0
    @State private var pairing: Bool = false
    @State private var repeated = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    var body: some View {
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
                        .frame(width: 350, height: 350)
                }
                ZStack {
                    if !pairing {
                        if bleManager.connectedPeripheral == nil{
                            Button(action: {
                                pairing = true
                                bleManager.startScanning()
                                pairing = false
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
                        } else {
                            NavigationLink(destination: SetupView()){
                                Text("Setup ring")
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.black))
                                    .transition(.opacity)
                                }
                        }
                    } else {
                        Text("Searching for a ring...")
                            .foregroundColor(Color(UIColor.systemGray))
                            .padding(.all, 14.0)
                            .opacity(opacityANIMATION)
                            .onAppear {
                                DispatchQueue.main.async {
                                    withAnimation(repeated){
                                        opacityANIMATION = 1.0
                                    }
                                }
                            }
                            .transition(.opacity)
                    }
                }
                .frame(width: 400, height: 80)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear(){
                if stats.isEmpty {
                    let SPO2DataObject = StatDataObject(inputName: "SPO2", context: moc, empty: true)
                    let HeartRateDataObject = StatDataObject(inputName: "HeartRate", context: moc, empty: true)
                    let SystolicPressureDataObject = StatDataObject(inputName: "SystolicPressure", context: moc, empty: true)
                    let DiastolicPressureDataObject = StatDataObject(inputName: "DiastolicPressure", context: moc, empty: true)
                    try? moc.save()
                }
            }
        }
        .environmentObject(bleManager)
        .environmentObject(user)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
