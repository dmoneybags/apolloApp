//
//  RingPowerView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/13/22.
//

import SwiftUI
import SceneKit

struct RingPowerView: View {
    @EnvironmentObject var changingRingSettings: observableBool
    var batteryPercent: Double
    @State private var opacityAnimator: Bool = false
    var body: some View {
        ZStack{
            Color.black
                .opacity(opacityAnimator ? 0.4 : 0.0)
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            VStack{
                HStack{
                    Spacer()
                    Text("Battery Level")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.leading, 35)
                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                        .foregroundColor(Color(UIColor.systemGray))
                        .onTapGesture(){
                            changingRingSettings.value = false
                        }
                }
                .padding(.top)
                Spacer()
                ZStack{
                    RingChart(progress: .constant(batteryPercent), text: .constant(""))
                        .frame(width: 250, height: 250)
                    SceneView(
                        scene: {
                            let scene = SCNScene(named: "Apollo 1 Ring.obj")!
                            scene.background.contents = UIColor.white
                            return scene
                        }(),
                        options: [.autoenablesDefaultLighting,.allowsCameraControl])
                        .scaleEffect(0.6)
                        .frame(width: 250, height: 250)
                }
                .padding()
                .frame(width: 250, height: 250)
                Text(String(format: "%.01f", batteryPercent * 100) + "%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(colors: [.green,.blue], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
                Button("Change ring settings"){
                    print("Openning ring setting window")
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.width + 90)
            .background(.white)
            .cornerRadius(20)
        }
        .onAppear(){
            withAnimation(.easeInOut(duration: 1.5)){
                opacityAnimator = true
            }
        }
        .onDisappear(){
            withAnimation(.easeInOut(duration: 1.5)){
                opacityAnimator = false
            }
        }
    }
}
