//
//  bpmMiniBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/26/21.
//

import SwiftUI

struct bpmMiniBox: View {
    @Environment(\.colorScheme) var colorScheme
    @State var title: String = "BPM"
    @State var loaded: Bool = false
    @Binding var data: Double
    var body: some View {
        VStack{
            Text(title)
                .fontWeight(.bold)
            VStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: loaded ? 70:100, height: loaded ? 70:100, alignment: .center)
                    .foregroundColor(Color.pink)
                    .onAppear(){
                        withAnimation(Animation.easeInOut(duration: 60/data).repeatForever()){
                            loaded = true
                        }
                    }
            }
            .frame(width: 100, height: 100, alignment: .center)
            Text(String(data))
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(width: 150, height: 210, alignment: .center)
        .background(colorScheme != .dark ? Color.white: Color.black)
        .cornerRadius(15)
    }
}

struct bpmMiniBox_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            bpmMiniBox(data: .constant(0.0)).preferredColorScheme($0)
        }
    }
}
