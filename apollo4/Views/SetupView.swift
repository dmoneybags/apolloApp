//
//  SetupView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/7/21.
//

import SwiftUI
import UIKit

struct SetupView: View {
    @EnvironmentObject var user: UserData
    var body: some View {
        VStack {
            containedView()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.blue]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 2)))
        .edgesIgnoringSafeArea(.all)
    }
    func containedView() -> AnyView {
        switch self.user.stage {
        case 0: return AnyView(nameSetup())
        case 1: return AnyView(userDataInputSetup())
        case 2: return AnyView(healthSetupView())
        case 3: return AnyView(finishedSetupView())
        default: return AnyView(MainView2())
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
