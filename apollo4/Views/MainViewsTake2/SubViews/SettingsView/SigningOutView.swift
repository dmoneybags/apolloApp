//
//  SigningOutView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/24/22.
//

import SwiftUI


struct SignOutLoadAnimation: View {
    
    @State private var shouldAnimate = false
    
    var body: some View {
        HStack {
            Circle()
                .fill(.white)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever())
            Circle()
                .fill(.white)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
            Circle()
                .fill(.white)
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
    
}
struct SigningOutView: View {
    @State var shouldProceed: Bool = false
    var body: some View {
        VStack{
            Image("logowhttrans")
                .resizable()
                .frame(width: 100, height: 50, alignment: .center)
                .padding(.top, 30)
            Divider()
                .padding(.horizontal,  30)
            Text("Signing Out")
                .font(.title2)
            SignOutLoadAnimation()
                .padding()
        }
        .fullScreenCover(isPresented: $shouldProceed){
            ContentView()
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
        }
        .onAppear{
            if UserData.shared.isSignedIn == false{
                shouldProceed = true
            }
        }
        .onChange(of: UserData.shared.isSignedIn){status in
            if !status{
                shouldProceed = true
            }
        }
    }
}

struct SigningOutView_Previews: PreviewProvider {
    static var previews: some View {
        SigningOutView().preferredColorScheme(.dark)
    }
}
