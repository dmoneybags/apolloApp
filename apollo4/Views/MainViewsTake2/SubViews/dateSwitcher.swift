//
//  dateSwitcher.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/27/21.
//

import SwiftUI
//Date Switcher to switch day of data being looked at by initializing the view at the top level:
//var dateSwitch = dateSwitcher()
//let offset = dateSwitch.offset
class Offset: ObservableObject {
    @Published var num: Int
    init(num: Int){
        self.num = num
    }
}
struct DateSwitcher: View {
    @EnvironmentObject var offset : Offset
    @Environment(\.colorScheme) var colorScheme
    var dates : [Date]
    //Increment an offset which we will then use to get the data by calling the filterDataTuples function
    private var dateStr : String {
        return getTimeComponent(date: Date(timeIntervalSince1970: getMostRecentDate(usingDates: dates, in: .day, withOffset: offset.num)), timeFrame: .year)
    }
    var body: some View {
        ZStack{
            Capsule()
            HStack{
                Image(systemName: "lessthan.circle.fill")
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 5)
                    .onTapGesture {
                        if offset.num < dates.count - 1{
                            offset.num += 1
                        }
                    }
                Spacer()
                Text(dateStr)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                Spacer()
                Image(systemName: "lessthan.circle.fill")
                    .foregroundColor(Color.blue)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(.horizontal, 5)
                    .onTapGesture {
                        if offset.num > 0 {
                            offset.num -= 1
                        }
                    }
            }
        }
        .frame(width: 150, height: 30)
    }
    
}
