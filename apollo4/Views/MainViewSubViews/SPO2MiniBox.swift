//
//  SPO2MiniBox.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/27/21.
//

import SwiftUI

struct SPO2MiniBox: View {
    @Environment(\.colorScheme) var colorScheme
    @State var title: String = "BPM"
    @State var imageName: String = "wind"
    @State var loaded: Bool = true
    @State var stat: String = "SPO2"
    @Binding var data: Double
    var body: some View {
        VStack{
            Text(title)
                .fontWeight(.bold)
            VStack {
                RingChart(progress: .constant(getProgress(stat: stat, reading: data) * 0.95), text: .constant(title), imageName: imageName, stat: stat)
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


struct SPO2MiniBox_Previews: PreviewProvider {
    static var previews: some View {
        SPO2MiniBox(data: .constant(0.0))
    }
}
