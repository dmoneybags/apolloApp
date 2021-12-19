//
//  SegmentedRingChartView.swift
//  apollo4
//
//  Created by Daniel DeMoney on 12/6/21.
//
//ONLY USABLE FOR BLOOD PRESSURE
import SwiftUI

struct SegmentedRingChartView: View {
    @State var loaded: Bool = false
    @State private var inFocus: Int = 1000
    var stat: Stat
    var dataList: [(Double, Date)]
    var keys: [String]{
        return genDataDict(unsortedData: dataList).1
    }
    var sortedDict: [String : [(Double, Date)]]{
        return genDataDict(unsortedData: dataList).0
    }
    var scaleEffect: Double = 1.3
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.2)
            ForEach(keys.indices, id:\.self){indice in
                let doubleList = sortedDict[keys[indice]]!.map{$0.0}
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(loaded ? getPercentOfRing(dict: sortedDict, key: keys[indice]): 0.0, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(stat.getColor(forLabel: keys[indice]).opacity(0.9))
                    .rotationEffect(Angle(degrees: getSectionDegrees(dict: sortedDict, key: keys[indice]) * 360 + 270))
                    .scaleEffect(inFocus != indice ? 1.0 : scaleEffect)
                    .zIndex(Double(10 - indice))
                    .onTapGesture {
                        withAnimation(Animation.easeInOut(duration: 1.0)){
                            if inFocus != indice{
                                inFocus = indice
                            } 
                            
                        }
                    }
                Circle()
                    .trim(from: 0.0, to: 0.001)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(stat.getColor(forLabel: keys[indice]).opacity(0.9))
                    .rotationEffect(Angle(degrees: getSectionDegrees(dict: sortedDict, key: keys[indice]) * 360 + 270))
                    .scaleEffect(inFocus != indice ? 1.0 : scaleEffect)
                    .onTapGesture {
                        withAnimation(Animation.easeInOut(duration: 1.0)){
                            if inFocus != indice{
                                inFocus = indice
                            }
                            
                        }
                    }
            }
            if inFocus < keys.count{
                SegmentedChartViewCenter(index: $inFocus, stat: stat, keys: keys, sortedDict: sortedDict)
            } else {
                VStack{
                    Text("Usually " + stat.getLabel(reading: averageData(data: dataList.map{$0.0})))
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Divider()
                }
                .padding(.all, 30)
            }
        }
        .onAppear(){
            withAnimation(Animation.easeInOut(duration: 3.0)){
                loaded = true
            }
        }
    }
    func genDataRanges(data: [(Double, Date)]) -> [[(Double, Date)]]{
        let min = data.map{$0.0}.min()!
        let max = data.map{$0.0}.max()!
        let range = max - min
        var increment: Double
        if range > 20 {
            increment = 10
        } else if range > 10 {
            increment = 5
        } else {
            increment = 2
        }
        var sortedList: [[(Double, Date)]] = []
        for i in 0..<Int(range/increment + 1){
            sortedList.append([])
        }
        for val in data{
            let index = Int((val.0 - min)/increment)
            sortedList[index].append(val)
        }
        return sortedList
    }
    func genDataDict(unsortedData: [(Double, Date)]) -> ([String : [(Double, Date)]], [String]){
        var newKeys : [String] = []
        let data = unsortedData.sorted(by: {$0.0 < $1.0})
        var sortedDict = [String : [(Double, Date)]]()
        for value in data{
            let key = stat.getLabel(reading: value.0)
            if let values = sortedDict[key]{
                var newList = values
                newList.append(value)
                sortedDict[key] = newList
            } else {
                newKeys.append(key)
                sortedDict[key] = [value]
            }
        }
        return (sortedDict, newKeys)
    }
    func getPercentOfRing(dict: [String : [(Double, Date)]], key: String) -> Double {
        let keyLen = dict[key]?.count
        var fullLen = 0
        for keyVal in keys{
            fullLen += dict[keyVal]!.count
        }
        return Double(keyLen!)/Double(fullLen)
    }
    func getSectionDegrees(dict: [String : [(Double, Date)]], key: String) -> Double {
        var len: Double = 0
        var indiceLen: Double = 0
        for key in keys{
            len += Double(dict[key]!.count)
        }
        for keyVal in keys{
            if keyVal == key{
                break
            }
            indiceLen += Double(dict[keyVal]!.count)
        }
        return Double(indiceLen)/len
    }
}

struct SegmentedRingChartView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedRingChartView(stat: SystolicPressure(), dataList: [(150.0, Date()), (117.0, Date()), (111.0, Date()), (118.0, Date()), (119.0, Date()), (129.0, Date()), (130.0, Date()), (179.0, Date()), (200.0, Date())]).preferredColorScheme(.dark)
            .frame(width: 200, height: 200)
    }
}
