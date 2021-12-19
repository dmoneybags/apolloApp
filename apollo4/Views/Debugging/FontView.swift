//
//  FontView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/14/21.
//

import SwiftUI

struct FontView: View {
    var body: some View {
        ScrollView{
            VStack{
                ForEach(UIFont.familyNames, id: \.self){family in
                    ForEach(UIFont.fontNames(forFamilyName: family),  id:\.self){name in
                        Text(name).font(.custom(name, size: 33))
                    }
                }
            }
        }
    }
}

struct FontView_Previews: PreviewProvider {
    static var previews: some View {
        FontView()
    }
}
