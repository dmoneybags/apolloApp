//
//  swipeView.swift
//  apollo2
//
//  Created by Daniel DeMoney on 11/11/21.
//

import SwiftUI

struct swipeView: View {
    @State private var shouldAnimate = false
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "play.fill")
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                    .scaleEffect(shouldAnimate ? 1.3 : 0.5)
                    .animation(Animation.easeInOut(duration: 1).repeatForever())
                Image(systemName: "play.fill")
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                    .scaleEffect(shouldAnimate ? 1.3 : 0.5)
                    .animation(Animation.easeInOut(duration: 1).repeatForever().delay(0.3))
                Image(systemName: "play.fill")
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                    .scaleEffect(shouldAnimate ? 1.3 : 0.5)
                    .animation(Animation.easeInOut(duration: 1).repeatForever().delay(0.6))
            }
            .onAppear {
                self.shouldAnimate = true
            }
        }
    }
}

struct swipeView_Previews: PreviewProvider {
    static var previews: some View {
        swipeView()
    }
}
