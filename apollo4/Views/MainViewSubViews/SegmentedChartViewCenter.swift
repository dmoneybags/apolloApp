//
//  SegmentedChartViewCenter.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/7/21.
//

import SwiftUI

struct SegmentedChartViewCenter: View {
    @Binding var index: Int
    var stat: Stat
    var keys : [String]
    var sortedDict: [String : [(Double, Date)]]
    var body: some View {
        let minColor = getColor(stat: stat.name, progress: getProgress(stat: stat.name, reading: sortedDict[keys[index]]!.map{$0.0}.min()!))
        let maxColor = getColor(stat: stat.name, progress: getProgress(stat: stat.name, reading: sortedDict[keys[index]]!.map{$0.0}.max()!))
        VStack{
            Text(keys[index])
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal)
                .animation(.none)
            Text(String(Int(getPercentOfRing(dict: sortedDict, key: keys[index]) * 100)) + "% of the time")
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .animation(.none)
            Divider()
            Text(String(stat.getRange(label: keys[index]).0) + "-" + String(stat.getRange(label: keys[index]).1))
            Text(stat.measurement)
            GeometryReader{ geo in
                HorizontalCapsuleReader(progress: computeProgress(), width: geo.frame(in: .local).maxX - 30, height: 15, gradient: Gradient(colors: [minColor, maxColor]))
                    .padding(.leading, 15)
                
            }
            .frame(height: 15)
            //Text(headline)
        }
        .padding(.all, 30)
        .animation(.spring())
    }
    func getPercentOfRing(dict: [String : [(Double, Date)]], key: String) -> Double {
        let keyLen = dict[key]?.count
        var fullLen = 0
        for keyVal in keys{
            fullLen += dict[keyVal]!.count
        }
        return Double(keyLen!)/Double(fullLen)
    }
    func computeProgress() -> Double {
        return (averageData(data: sortedDict[keys[index]]!.map{$0.0}) - stat.getRange(label: keys[index]).0)/(stat.getRange(label: keys[index]).1 - stat.getRange(label: keys[index]).0)
    }
}
