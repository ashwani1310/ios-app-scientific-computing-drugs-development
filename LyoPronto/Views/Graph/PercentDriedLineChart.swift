//
//  SwiftUIView.swift
//  LyoPronto

import SwiftUI
import Charts

struct PercentDriedLineChart: View {
    
    @Binding var selectedElement: PDOutputModel?
    
    var primaryDryingModel: [PDOutputModel] = []
    var rangeValues: RangeValuesForGraph
    
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
        var minY = rangeVal.minDriedPercent
        var maxY = rangeVal.maxDriedPercent
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
                    y: .value("Percent Dried", $0.driedPercent)
                )
                .foregroundStyle(by: .value("Value", "Percent Dried"))
                
            }
            .lineStyle(StrokeStyle(lineWidth: 2.0))
            .interpolationMethod(.catmullRom)
            
            if let selectedElement = selectedElement {
                PointMark(
                    x: .value("Time", selectedElement.time),
                    y: .value("Percent Dried", selectedElement.driedPercent)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.teal
                )
            }
            
        }
        .chartForegroundStyleScale([
            "Percent Dried": .teal
        ])
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
    

struct PercentDriedLineChartView: View {
    
    @State private var selectedElement: PDOutputModel? = nil
    @Environment(\.layoutDirection) var layoutDirection
    
    var primaryDryingModel: [PDOutputModel] = []
    var rangeValues: RangeValuesForGraph
    
    var body: some View {
        VStack{
            Spacer().frame(height:10)
            ZStack{
                GroupBox("Percent Dried") {
                    Spacer()
                        .frame(height:50)
                    
                        PercentDriedLineChart(selectedElement: $selectedElement, primaryDryingModel: primaryDryingModel, rangeValues: rangeValues)
                            .frame(maxHeight: .infinity)
                            .chartBackground { proxy in
                                GeometryReader { nthGeoItem in
                                    if let selectedElement = selectedElement {
                                        let startPositionX = proxy.position(forX: selectedElement.time) ?? 0
                                        let xPosition = startPositionX + nthGeoItem[proxy.plotAreaFrame].origin.x
                                        let lineX = layoutDirection == .rightToLeft ? nthGeoItem.size.width - xPosition : xPosition
                                        let lineHeight = nthGeoItem[proxy.plotAreaFrame].maxY
                                        let boxWidth: CGFloat = 150
                                        let boxOffset = max(0, min(nthGeoItem.size.width - boxWidth, lineX - boxWidth / 2))
                                        
                                        Rectangle()
                                            .fill(.quaternary)
                                            .frame(width: 2, height: lineHeight)
                                            .position(x: lineX, y: lineHeight / 2)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Time: \(String(format: "%.2f", selectedElement.time)) hours")
                                                .font(.callout)
                                                .foregroundStyle(.secondary)
                                            Text("Dried:  \(String(format: "%.2f", selectedElement.driedPercent)) %")
                                                .font(.body.bold())
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
