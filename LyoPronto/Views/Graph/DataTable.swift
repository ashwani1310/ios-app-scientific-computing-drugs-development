//
//  DataTable.swift
//  LyoPronto
//

import SwiftUI
import Tabler
import Sideways

struct DataTableView: View {
    
    let data: [PDOutputModel]
    
    init(data: [PDOutputModel]) {
        self.data = data
    }
    
    
    private var gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
    ]
    
    
    private typealias Context = TablerContext<PDOutputModel>
    
    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("Time (hr)")
            Text("Sublimation Temperature (\u{2103})")
            Text("Vial Bottom Temperature (\u{2103})")
            Text("Shelf Temperature (\u{2103})")
            Text("Chamber Pressure (mTorr)")
            Text("Sublimation Flux (kg/hr/m\u{00B2})")
            Text("Percent Dried")
        }
    }
    
    private func row(pdata: PDOutputModel) -> some View {
        LazyVGrid(columns: gridItems) {
            Text(String(format: "%.4f", pdata.time))
            Text(String(format: "%.4f", pdata.sublimationTemprature))
            Text(String(format: "%.4f", pdata.vialBottomTemprature))
            Text(String(format: "%.4f", pdata.shelfTemperature))
            Text(String(format: "%.4f", pdata.chamberPressure))
            Text(String(format: "%.4f", pdata.sublimationFlux))
            Text(String(format: "%.4f", pdata.driedPercent))
        }
    }
    
    
    var body: some View {
        TablerList(header: header,
                   row: row,
                   results: data)
        .sideways(minWidth: 1000)
    }
}



struct FreezingDataTableView: View {
    
    let data: [FreezingOutputModel]
    
    init(data: [FreezingOutputModel]) {
        self.data = data
    }
    
    
    private var gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
    ]
    
    
    private typealias Context = TablerContext<FreezingOutputModel>
    
    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("Time (hr)")
            Text("Shelf Temperature (\u{2103})")
            Text("Product Temperature (\u{2103})")
        }
    }
    
    private func row(pdata: FreezingOutputModel) -> some View {
        LazyVGrid(columns: gridItems) {
            Text(String(format: "%.4f", pdata.time))
            Text(String(format: "%.4f", pdata.shelfTemperature))
            Text(String(format: "%.4f", pdata.productTemperature))
        }
    }
    
    var body: some View {
        TablerList(header: header,
                   row: row,
                   results: data)
        .sideways(minWidth: 1000)
    }
}


struct DesignSpaceDataTableView: View {
    
    let data: [DSTableOutputModel]
    
    init(data: [DSTableOutputModel]) {
        self.data = data
    }
    
    
    private var gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading),
        GridItem(.flexible(minimum: 100), alignment: .leading)
    ]
    
    
    private typealias Context = TablerContext<DSTableOutputModel>
    
    private func header(ctx: Binding<Context>) -> some View {
        LazyVGrid(columns: gridItems) {
            Text("Type")
            Text("Value")
            Text("Chamber Pressure (mTorr)")
            Text("Maximum Product Temperature (\u{2103})")
            Text("Drying Time (hours)")
            Text("Average Sublimation Flux (kg/hr/m\u{00B2})")
            Text("Maximum/Minimum Sublimation Flux (kg/hr/m\u{00B2})")
            Text("Final Sublimation Flux (kg/hr/m\u{00B2})")
        }
    }
    
    private func row(pdata: DSTableOutputModel) -> some View {
        LazyVGrid(columns: gridItems) {
            Text(pdata.type)
            Text(pdata.value)
            Text(String(format: "%.2f", pdata.pressure))
            Text(String(format: "%.4f", pdata.temperature))
            Text(String(format: "%.4f", pdata.time))
            Text(String(format: "%.4f", pdata.sublimationAvg))
            Text(String(format: "%.4f", pdata.sublimationMax))
            Text(String(format: "%.4f", pdata.sublimationFinal))
        }
    }
    
    var body: some View {
        TablerList(header: header,
                   row: row,
                   results: data)
        .sideways(minWidth: 1000)
    }
}
