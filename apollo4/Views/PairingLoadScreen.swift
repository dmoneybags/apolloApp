//
//  PairingLoadScreen.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/5/21.
//

import SwiftUI

struct PairingLoadScreen: View {
    @State private var shouldAnimate = false
    var body: some View {
        HStack(alignment: .center, spacing: shouldAnimate ? 15 : 5) {
                    Capsule(style: .continuous)
                        .fill(Color.blue)
                        .frame(width: 10, height: 50)
                    Capsule(style: .continuous)
                        .fill(Color.blue)
                        .frame(width: 10, height: 30)
                    Capsule(style: .continuous)
                        .fill(Color.blue)
                        .frame(width: 10, height: 50)
                    Capsule(style: .continuous)
                        .fill(Color.blue)
                        .frame(width: 10, height: 30)
                    Capsule(style: .continuous)
                        .fill(Color.blue)
                        .frame(width: 10, height: 50)
                }
                .frame(width: shouldAnimate ? 150 : 100)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
                .onAppear {
                    self.shouldAnimate = true
                }
    }
}

struct PairingLoadScreen_Previews: PreviewProvider {
    static var previews: some View {
        PairingLoadScreen()
    }
}
