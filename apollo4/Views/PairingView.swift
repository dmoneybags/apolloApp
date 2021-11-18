//
//  PairingView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/5/21.
//

import SwiftUI

struct PairingView: View {
    var body: some View {
        VStack {
            Text("Searching for device")
                .font(.title)
            Divider()
                .padding(.horizontal, 20.0)
                .padding(.bottom, 10.0)
            PairingLoadScreen()
        }
        .navigationBarHidden(true)
        .navigationBarTitle(Text("Home"))
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct PairingView_Previews: PreviewProvider {
    static var previews: some View {
        PairingView()
    }
}
