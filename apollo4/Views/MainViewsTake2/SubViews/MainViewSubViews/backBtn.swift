//
//  backBtn.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/28/21.
//

import SwiftUI

struct backBtn: View {
    var body: some View {
        Button("Back", action: {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "vitalView"), object: "exit")
        })
            .foregroundColor(Color.blue)
    }
}

struct backBtn_Previews: PreviewProvider {
    static var previews: some View {
        backBtn()
    }
}
