//
//  DesignSpaceTemp.swift
//  LyoPronto
//

import SwiftUI
import Charts

struct DSTempLineChart: View {
    
    @Binding var selectedElement: DSGraphOutputModel?
    @State private var colorList = [Color.teal, Color.purple, Color.green, Color.red, Color.blue, Color.black, Color.brown]
    
    var designSpaceModel: [DSGraphOutputModel] = []
    var addValues: AdditionalValuesForDSGraph
   
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedItem: DSGraphOutputModel = DSGraphOutputModel()
    
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> DSGraphOutputModel? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let time = proxy.value(atX: relativeXPosition) as Double? {
            
            var minDistance: Double = Double(Int.max)
            var index: Int? = nil
            
            for dataIndex in designSpaceModel.indices {
                let nthDataDistance = time - designSpaceModel[dataIndex].pressure
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return designSpaceModel[index]
            }
        }
        return nil
    }
    

    func getXAxisValues (addValues: AdditionalValuesForDSGraph) -> (Double, Double, Double)  {
        var maxX = addValues.maxPressure
        var minX = addValues.minPressure
        
        if (minX == maxX) {
            minX -= 5
            maxX += 5
        }
        let distance = abs(maxX - minX)
        var strideBy = distance/5
        
        if (distance > 5.0 && distance.truncatingRemainder(dividingBy: 5.0) != 0) {
            strideBy = (distance + 5)/5
        }
        
        return (minX, maxX, strideBy)
        
    }
    
    func getYAxisValues (addValues: AdditionalValuesForDSGraph) -> (Double, Double, Double) {
        var minY = addValues.minTemperature
        var maxY = addValues.maxTemperature
        if (minY == maxY) {
            minY -= 5
            maxY += 5
        }
    
        let distance = abs(maxY - minY)
        var strideBy = distance/5
        if (distance > 5.0 && distance.truncatingRemainder(dividingBy: 5.0) != 0) {
            strideBy = (distance + 5)/5
        }
        
        return (minY, maxY, strideBy)
        
    }
    
    
    
    func graphColors() -> [Color] {
        var returnColors = [Color]()
        for index in 0..<addValues.description.count {
            returnColors.append(colorList[index])
        }
        return returnColors
    }
    
    var body: some View {
        
        let (xMin, xMax, xStride) = getXAxisValues(addValues: addValues)
        let (yMin, yMax, yStride) = getYAxisValues(addValues: addValues)

        Chart {
            ForEach(designSpaceModel.sorted(by: {$0.pressure < $1.pressure}), id: \.id) { value in
                ForEach(value.shelfTemp.indices, id: \.self){ index in
                    LineMark(
                        x: .value("Chamber Pressure", value.pressure),
                        y: .value("\(addValues.description[index])", value.temperature[index])
                    )
                    .foregroundStyle(by: .value("Value", "\(addValues.description[index])"))
                }
            }
            .lineStyle(StrokeStyle(lineWidth: 2.0))
            .interpolationMethod(.catmullRom)
            
            if let selectedElement = selectedElement {
                ForEach(selectedElement.shelfTemp.indices, id: \.self){ index in
                    PointMark(
                        x: .value("Chamber Pressure", selectedElement.pressure),
                        y: .value("\(addValues.description[index])", selectedElement.temperature[index])
                    )
                    .symbolSize(100.0)
                    .foregroundStyle(
                        colorList[index]
                    )
                }
            }
            
        }
        .chartForegroundStyleScale(range: graphColors())
        .chartXAxis {
            AxisMarks(preset: .automatic, position: .bottom, values: Array(stride(from: xMin, through: xMax+xStride, by: xStride)))
        }
        .chartXScale(domain: xMin...xMax+xStride)
        .chartYAxis {
            AxisMarks(position: .leading, values: Array(stride(from: yMin, through: yMax+yStride, by: yStride)))
        }
        .chartYScale(domain: yMin...yMax+yStride)
        .chartOverlay { proxy in
            GeometryReader { nthGeometryItem in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: nthGeometryItem)
                                if selectedElement?.pressure == element?.pressure {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: nthGeometryItem)
                                    }
                            )
                    )
            }
        }
    }
}


struct DSTempChartView: View {
    
    @State private var selectedElement: DSGraphOutputModel? = nil
    @Environment(\.layoutDirection) var layoutDirection
    
    @State private var colorList = [Color.teal, Color.purple, Color.green, Color.red, Color.blue, Color.black, Color.brown]
    
    var designSpaceModel: [DSGraphOutputModel] = []
    var addValues: AdditionalValuesForDSGraph
    
    var body: some View {
        VStack{
            Spacer().frame(height:10)
            ZStack {
                GroupBox("Product Temperatures") {
                    Spacer()
                        .frame(height:50)
                    
                    DSTempLineChart(selectedElement: $selectedElement, designSpaceModel: designSpaceModel, addValues: addValues)
                        .frame(maxHeight: .infinity)
                        .chartBackground { proxy in
                            GeometryReader { nthGeoItem in
                                if let selectedElement = selectedElement {
                                    let startPositionX = proxy.position(forX: selectedElement.pressure) ?? 0
                                    let xPosition = startPositionX + nthGeoItem[proxy.plotAreaFrame].origin.x
                                    let lineX = layoutDirection == .rightToLeft ? nthGeoItem.size.width - xPosition : xPosition
                                    let lineHeight = nthGeoItem[proxy.plotAreaFrame].maxY
                                    let boxWidth: CGFloat = 200
                                    let boxOffset = max(0, min(nthGeoItem.size.width - boxWidth, lineX - boxWidth / 2))
                                    
                                    Rectangle()
                                        .fill(.quaternary)
                                        .frame(width: 2, height: lineHeight)
                                        .position(x: lineX, y: lineHeight / 2)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Pressure: \(String(format: "%.2f", selectedElement.pressure)) mTorr")
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                        ForEach(selectedElement.shelfTemp.indices, id: \.self) { index in
                                            Text("\(addValues.shortDesc[index]): \(String(format: "%.2f", selectedElement.temperature[index])) \u{2103}")
                                                .font(.callout)
                                                .foregroundColor(colorList[index])
                                        }
                                    }
                                    .frame(width: boxWidth, alignment: .leading)
                                    .background {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.background)
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.quaternary.opacity(0.7))
                                        }
                                        .padding([.leading, .trailing], -8)
                                        .padding([.top, .bottom], -4)
                                    }
                                    .offset(x: boxOffset)
                                }
                            }
                        }
                }
            }
            Spacer().frame(height:50)
        }
        .frame(maxHeight: .infinity)
    }
}

