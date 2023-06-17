//
//  FreezingChartView.swift
//  LyoPronto
//

import SwiftUI
import Charts

struct FreezingLineChart: View {
    
    @Binding var selectedElement: FreezingOutputModel?
    
    var freezingModel: [FreezingOutputModel] = []
    var rangeValues: RangeValuesForFreezingGraph
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedItem: FreezingOutputModel = FreezingOutputModel()
    
    
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> FreezingOutputModel? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let time = proxy.value(atX: relativeXPosition) as Double? {
            
            var minDistance: Double = Double(Int.max)
            var index: Int? = nil
            
            for dataIndex in freezingModel.indices {
                let nthDataDistance = time - freezingModel[dataIndex].time
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return freezingModel[index]
            }
        }
        return nil
    }
    
    func getXAxisValues (rangeVal: RangeValuesForFreezingGraph) -> (Double, Double, Double)  {
        var maxX = rangeVal.maxTime
        var minX = rangeVal.minTime
        
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
    
    func getYAxisValues (rangeVal: RangeValuesForFreezingGraph) -> (Double, Double, Double) {
        var minY = min(rangeVal.minShelfTemprature, rangeVal.minProductTemprature)
        var maxY = max(rangeVal.maxShelfTemprature, rangeVal.maxProductTemprature)
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
    
    
    
    var body: some View {
        
        let (xMin, xMax, xStride) = getXAxisValues(rangeVal: rangeValues)
        let (yMin, yMax, yStride) = getYAxisValues(rangeVal: rangeValues)
        
        Chart {
            ForEach(freezingModel, id: \.id) {
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Shelf Temperature", $0.shelfTemperature)
                )
                .foregroundStyle(by: .value("Value", "Shelf Temperature"))
                
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Product Temperature", $0.productTemperature)
                )
                .foregroundStyle(by: .value("Value", "Product Temperature"))
            }
            .lineStyle(StrokeStyle(lineWidth: 2.0))
            .interpolationMethod(.catmullRom)
            
            if let selectedElement = selectedElement {
                PointMark(
                    x: .value("Time", selectedElement.time),
                    y: .value("Shelf Temperature", selectedElement.shelfTemperature)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.purple
                )
                PointMark(
                    x: .value("Time", selectedElement.time),
                    y: .value("Product Temperature", selectedElement.productTemperature)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.teal
                )
            }
            
        }
        .chartForegroundStyleScale([
            "Shelf Temperature": .purple,
            "Product Temperature": .teal
        ])
        .chartXAxis {
            AxisMarks(position: .bottom, values: Array(stride(from: xMin, through: xMax+xStride, by: xStride)))
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
                                if selectedElement?.time == element?.time {
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

struct FreezingChartView: View {
    
    @State private var selectedElement: FreezingOutputModel? = nil
    @Environment(\.layoutDirection) var layoutDirection
    
    var freezingModel: [FreezingOutputModel] = []
    var rangeValues: RangeValuesForFreezingGraph
    
    var body: some View {
        VStack{
            Spacer().frame(height:10)
            ZStack {
                GroupBox("Temperatures") {
                    Spacer()
                        .frame(height:50)
                    
                    FreezingLineChart(selectedElement: $selectedElement, freezingModel: freezingModel, rangeValues: rangeValues)
                        .frame(maxHeight: .infinity)
                        .chartBackground { proxy in
                            GeometryReader { nthGeoItem in
                                if let selectedElement = selectedElement {
                                    let startPositionX = proxy.position(forX: selectedElement.time) ?? 0
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
                                        Text("Time: \(selectedElement.time, format: .number) hours")
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                        Text("Shelf Temperature: \(String(format: "%.2f", selectedElement.shelfTemperature)) \u{2103}")
                                            .font(.callout)
                                            .foregroundColor(.purple)
                                        Text("Product Temperature: \(String(format: "%.2f", selectedElement.productTemperature)) \u{2103}")
                                            .font(.callout)
                                            .foregroundColor(.teal)
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

