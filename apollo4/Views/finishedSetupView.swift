//
//  finishedSetupView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import SwiftUI
import SceneKit

struct finishedSetupView: View {
    @EnvironmentObject var user: UserData
    @State private var stage = 0
    @State private var opacity = 0.0
    private var newscene = SceneView(
        scene: {
            let scene = SCNScene(named: "Apollo 1 Ring.obj")!
            scene.background.contents = UIColor.black
            return scene }(),
            options: [.allowsCameraControl,.autoenablesDefaultLighting]
            )
    var body: some View {
        VStack {
            VStack {
                Text("Finishing Setup...")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .padding()
                    .opacity(opacity)
                    .onAppear(){
                        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)){
                            opacity = 1.0
                        }
                    }
                HStack {
                    VStack {
                        if stage > 0 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                                .frame(width: 40, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
                        if stage > 1 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                                .frame(width: 40, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
                        if stage > 2 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                                .frame(width: 40, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
                    }
                    .frame(width: 80, height: 150)
                    //.background(Color.red)
                    VStack {
                        if stage > 0 {
                            Text("Stored data")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
                        Text("Loaded settings")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 40)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        Text("Configured ring")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 40)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                    }
                    .frame(width: 200, height: 150)
                    //.background(Color.blue)
                }
            }
            .frame(width: 280, height: 200, alignment: .center)
            self.newscene
                .background(Color.black)
                .scaleEffect(0.6)
                .frame(width: 350, height: 350)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear(){
            DispatchQueue.main.async {
                Backend.shared.signIn()
                stage = 1
                Backend.shared.createUser(user: user)
                stage = 2
                sleep(2)
                stage = 3
                sleep(2)
                stage = 4
            }
        }
    }
}

struct finishedSetupView_Previews: PreviewProvider {
    static var previews: some View {
        finishedSetupView()
    }
}
