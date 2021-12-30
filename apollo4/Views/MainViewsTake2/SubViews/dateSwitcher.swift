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
struct dateSwitcher: View {
    @Environment(\.colorScheme) var colorScheme
    var dates : [Date]
    //Increment an offset which we will then use to get the data by calling the filterDataTuples function
    @State var offset : Int = 0
    private var dateStr : String {
        return getTimeComponent(date: Date(timeIntervalSince1970: getMostRecentDate(usingDates: dates, in: .day, withOffset: offset)), timeFrame: .year)
    }
    var body: some View {
        ZStack{
            Capsule()
            HStack{
                Image(systemName: "lessthan.circle.fill")
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 5)
                    .onTapGesture {
                        if offset < dates.count - 1{
                            offset += 1
                            print(offset)
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
                        if offset > 0 {
                            offset -= 1
                            print(offset)
                        }
                    }
            }
        }
        .frame(width: 150, height: 30)
    }
    func getOffset() -> Int {
        return offset
    }
}
