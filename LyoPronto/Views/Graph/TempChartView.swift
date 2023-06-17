//
//  SwiftUIView.swift
//  LyoPronto

import SwiftUI
import Charts

struct TempratureLineChart: View {
    
    @Binding var selectedElement: PDOutputModel?
    
    var primaryDryingModel: [PDOutputModel] = []
    var rangeValues: RangeValuesForGraph
    var criticalTemp: Double
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedItem: PDOutputModel = PDOutputModel()
    
    
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> PDOutputModel? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let time = proxy.value(atX: relativeXPosition) as Double? {
            
            var minDistance: Double = Double(Int.max)
            var index: Int? = nil
            
            for dataIndex in primaryDryingModel.indices {
                let nthDataDistance = time - primaryDryingModel[dataIndex].time
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return primaryDryingModel[index]
            }
        }
        return nil
    }
    
    func getXAxisValues (rangeVal: RangeValuesForGraph) -> (Double, Double, Double)  {
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
    
    func getYAxisValues (rangeVal: RangeValuesForGraph) -> (Double, Double, Double) {
        var minY = min(rangeVal.minSublimationTemprature, min(rangeVal.minShelfTemperature, rangeVal.minVialBottomTemprature))
        minY = min(minY, criticalTemp)
        var maxY = max(rangeVal.maxSublimationTemprature, max(rangeVal.maxShelfTemperature, rangeVal.maxVialBottomTemprature))
        maxY = max(maxY, criticalTemp)
        
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
            ForEach(primaryDryingModel, id: \.id) {
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Sublimation Temperature", $0.sublimationTemprature)
                )
                .foregroundStyle(by: .value("Value", "Sublimation Temperature"))
                
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Vial Bottom Temperature", $0.vialBottomTemprature)
                )
                .foregroundStyle(by: .value("Value", "Vial Bottom Temperature"))
                
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Shelf Temperature", $0.shelfTemperature)
                )
                .foregroundStyle(by: .value("Value", "Shelf Temperature"))
                
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Critical Product Temperature", criticalTemp)
                )
                .foregroundStyle(by: .value("Value", "Critical Product Temperature"))
                
            }
            .lineStyle(StrokeStyle(lineWidth: 2.0))
            .interpolationMethod(.catmullRom)
            
            if let selectedElement = selectedElement {
                PointMark(
                    x: .value("Time", selectedElement.time),
                    y: .value("Sublimation Temperature", selectedElement.sublimationTemprature)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.purple
                )
                PointMark(
                    x: .value("Time", selectedElement.time),
                    y: .value("Vial Bottom Temperature", selectedElement.vialBottomTemprature)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.teal
                )
                PointMark(
                    x: .value("Time", selectedElement.time),
                    y: .value("Shelf Temperature", selectedElement.shelfTemperature)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.red
                )
                PointMark(
                    x: .value("Time", selectedElement.time),
                    y: .value("Critical Product Temperature", criticalTemp)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.green
                )
            }
            
        }
        .chartForegroundStyleScale([
            "Sublimation Temperature": .purple,
            "Vial Bottom Temperature": .teal,
            "Shelf Temperature": .red,
            "Critical Product Temperature": .green
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

struct TempratureChartView: View {
    
    @State private var selectedElement: PDOutputModel? = nil
    @Environment(\.layoutDirection) var layoutDirection
    
    var primaryDryingModel: [PDOutputModel] = []
    var rangeValues: RangeValuesForGraph
    var criticalTemp: Double
    
    var body: some View {
        VStack{
            Spacer().frame(height:10)
            ZStack {
                GroupBox("Temperatures") {
                    Spacer()
                        .frame(height:50)
                    
                    TempratureLineChart(selectedElement: $selectedElement, primaryDryingModel: primaryDryingModel, rangeValues: rangeValues, criticalTemp: criticalTemp)
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
                                        Text("Sublimation: \(String(format: "%.2f", selectedElement.sublimationTemprature)) \u{2103}")
                                            .font(.callout)
                                            .foregroundColor(.purple)
                                        Text("Vial Bottom: \(String(format: "%.2f", selectedElement.vialBottomTemprature)) \u{2103}")
                                            .font(.callout)
                                            .foregroundColor(.teal)
                                        Text("Shelf: \(selectedElement.shelfTemperature, format: .number) \u{2103}")
                                            .font(.callout)
                                            .foregroundColor(.red)
                                        Text("Critical: \(criticalTemp, format: .number) \u{2103}")
                                            .font(.callout)
                                            .foregroundColor(.green)
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
