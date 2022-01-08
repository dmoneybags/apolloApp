//
//  hrVarImage.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/5/22.
//

import SwiftUI

struct hrVarImage: View {
    var height: Double
    var width: Double
    var body: some View {
        ZStack{
            Image(systemName: "cross.fill")
                .resizable()
                .foregroundStyle(LinearGradient(colors: [.pink, .blue], startPoint: UnitPoint(x: 0.0, y: 0.0), endPoint: UnitPoint(x: 1.0, y: 1.0)))
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .padding([.top, .bottom], height * 0.3)
                .padding(.trailing, width * 0.15)
                .padding(.leading, width * 0.1)
        }
        .frame(width: width, height: height)
    }
}

struct hrVarImage_Previews: PreviewProvider {
    static var previews: some View {
        hrVarImage(height: 200, width: 200).preferredColorScheme(.dark)
    }
}
