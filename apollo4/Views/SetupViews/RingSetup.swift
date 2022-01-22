//
//  RingSetup.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/20/22.
//

import SwiftUI
import SceneKit
import NotificationBannerSwift

struct RingSetup: View {
    @EnvironmentObject var bleManager: BLEManager
    @FetchRequest(entity: StatDataObject.entity(), sortDescriptors: []) var stats: FetchedResults<StatDataObject>
    @State private var animator: Bool = false
    @State private var numBarsANIMATION: CGFloat = 1.25
    @State private var stage: Int = 0
    @State private var timeSinceLastStage: Int = 0
    @State private var finished: Bool = false
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    private let repeated = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    private let errorBanner = NotificationBanner(title: "Lost connection to ring", subtitle: "", style: .danger)
    private let errorDataBanner = NotificationBanner(title: "Can't collect data", subtitle: "Make sure you are wearing the ring on the proper finger in the correct orientation and try again", style: .warning)
    private let successBanner = NotificationBanner(title: "Connected to Ring!", subtitle: "Resuming set up", style: .success)
    var body: some View {
        VStack{
            HStack{
                Text("Setting up ring...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(30)
                    .opacity(animator ? 1.0 : 0.2)
                    .scaleEffect(1.2)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 1.5).repeatForever()){
                            animator.toggle()
                        }
                    }
                Spacer()
            }
            Divider()
            if bleManager.connectedPeripheral != nil{
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Spacer()
                    Text("Set up account")
                        .font(.title)
                }
                .padding(.horizontal, 30)
                .padding()
                .offset(x: stage < 1 ? -500: 0, y:  0)
                .onAppear{
                    withAnimation{
                        stage = 1
                    }
                }
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Spacer()
                    Text("Calibrated Ring")
                        .font(.title)
                }
                .padding(.horizontal, 30)
                .padding()
                .offset(x: stage < 2 ? -500: 0, y:  0)
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Spacer()
                    Text("Collected Data")
                        .font(.title)
                }
                .padding(.horizontal, 30)
                .padding()
                .offset(x: stage < 3 ? -500: 0, y:  0)
                .onAppear{
                    withAnimation{
                        stage = 3
                    }
                }
            } else {
                Group{
                    Text("Error!").foregroundColor(.red) + Text(" Ring is not connected, hold ring close to device or press button below to manually search for device")
                    
                }
                .padding(.horizontal)
                .font(.title3)
                Spacer()
            }
            SceneView(
                scene: {
                    let scene = SCNScene(named: "Apollo 1 Ring.obj")!
                    scene.background.contents = UIColor.black
                    return scene
                }(),
                options: [.autoenablesDefaultLighting,.allowsCameraControl])
                .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.width/1.5)
                .padding()
            if bleManager.connectedPeripheral == nil {
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
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $finished){
            MainView2(showSuccess: true)
        }
        .onReceive(timer){_ in
            if stage == 3{
                finished = true
            }
            if stage < 3 && bleManager.connectedPeripheral != nil {
                timeSinceLastStage += 1
                if timeSinceLastStage > 60 {
                    errorDataBanner.show()
                    timeSinceLastStage = 0
                }
                var lowestLen = 5
                for stat in stats{
                    if stat.data.count < lowestLen{
                        lowestLen = stat.data.count
                    }
                }
                if lowestLen > 4 && stage == 2{
                    print("Moving to stage 3")
                    withAnimation(.easeInOut(duration: 1.5)){
                        stage = 3
                    }
                    timeSinceLastStage = 0
                }
                if lowestLen > 0 && stage == 1{
                    print("Moving to stage 2")
                    withAnimation(.easeInOut(duration: 1.5)){
                        stage = 2
                    }
                    timeSinceLastStage = 0
                }
            }
        }
        .onChange(of: bleManager.connectedPeripheral){peripheral in
            if peripheral == nil {
                errorBanner.show()
            } else {
                successBanner.show()
            }
        }
    }
}
