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
    @State private var showSecondStage = false
    @State private var showThirdStage = false
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
                        if user.isSignedIn {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                                .frame(width: 40, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                .onTapGesture {
                                    showSecondStage = true
                                }
                                .onAppear(){
                                    Backend.shared.createUser(user: user)
                                }
                        }
                        if showSecondStage {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                                .frame(width: 40, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                .onTapGesture {
                                    showThirdStage = true
                                }
                        }
                        if showThirdStage {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.green)
                                .frame(width: 40, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
                    }
                    .frame(width: 80, height: 150)
                    //.background(Color.red)
                    VStack {
                        if user.isSignedIn {
                            Text("Created user")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height: 40)
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
                        if showSecondStage {
                            Text("Loaded settings")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height: 40)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
                        if showThirdStage {
                            Text("Configured ring")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height: 40)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                        }
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
            Backend.shared.reauth()
        }
    }
}

struct finishedSetupView_Previews: PreviewProvider {
    static var previews: some View {
        finishedSetupView()
    }
}
