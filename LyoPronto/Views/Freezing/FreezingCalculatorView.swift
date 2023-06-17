//
//  PDCalculatorView.swift
//  LyoPronto
//

import Foundation
import SwiftUI



struct FreezingCalculatorOutputView: View {
    
    @StateObject private var vm = FreezingOutputViewModel()
    @State private var selectedPickerSegnment = 0
    @State private var selectedChart = 0
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var calculaterUserInputModel: FreezingModel
    @State var shareFile: ShareFile?
    @State var loadingView = false
        
    var body: some View {
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }
                    .padding([.vertical, .leading])
                    Picker("", selection: $selectedPickerSegnment) {
                        Text("Charts").tag(0)
                        Text("Table").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.all)
                    Button(action: {
                        loadingView = true
                        if let url = shareFreezingCSV(vm.getFreezingResult().1) {
                            shareFile = ShareFile(filePath: url)
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                    .padding([.vertical, .trailing])
                }
                .sheet(item: $shareFile, onDismiss: {
                    loadingView = false
                }) { shareFile in
                    ShareSheet(url: shareFile.filePath)
                }
                if($vm.freezingCalculatorResult.isEmpty) {
                    GraphLoaderAnimation()
                } else {
                     if(selectedPickerSegnment == 0) {
                         Picker("", selection: $selectedChart) {
                             Text("Temperatures").tag(0)
                         }
                         .pickerStyle(.segmented)
                         .padding(.all)
                         FreezingChartView(freezingModel: vm.getFreezingResult().0, rangeValues: vm.getFreezingResult().2)
                    } else {
                        FreezingDataTableView(data: vm.getFreezingResult().1)
                    }
                }
            }
            .onAppear {
                if colorScheme == .dark {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .white
                    UIPageControl.appearance().pageIndicatorTintColor = .gray
                } else {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .black
                    UIPageControl.appearance().pageIndicatorTintColor = .gray
                }
                vm.computeResult(calculaterUserInputModel)
            }
            .overlay {
                if loadingView {
                    Rectangle()
                        .fill(Color.black).opacity(loadingView ? 0.2 : 0)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("Loading")
                    
                }
            }
    }
    
    private func shareFreezingCSV(_ freezing: [FreezingOutputModel]) -> URL? {
        
        var inputs = ", Input,\n"
        inputs += ", Input,\n"
        inputs += "Vial Area (cm\u{00B2}),  \(calculaterUserInputModel.av),\n"
        inputs += "Product Area (cm\u{00B2}),  \(calculaterUserInputModel.ap),\n"
        inputs += "Fill Volume (mL),  \(calculaterUserInputModel.vfill),\n"
        inputs += ", Product,\n"
        inputs += "Solid Content (%w/v),  \(calculaterUserInputModel.cSolid),\n"
        inputs += "Critical Product Temperature (\u{2103}),  \(calculaterUserInputModel.cr_temp),\n"
        inputs += "Initial Product Temperature (\u{2103}),  \(calculaterUserInputModel.tpr0),\n"
        inputs += "Freezing Temperature (\u{2103}),  \(calculaterUserInputModel.tf),\n"
        inputs += "Nucleation Temperature (\u{2103}),  \(calculaterUserInputModel.tn),\n"
        inputs += ", Shelf Temperature,\n"
        inputs += "Initial Shelf Temperature (\u{2103}),  \(calculaterUserInputModel.ts_init_val),\n"
        inputs += "Ramp Rate (\u{2103}/minutes),  \(calculaterUserInputModel.ts_ramp_rate),\n"
        inputs += "Setpoint (\u{2103}),  \(calculaterUserInputModel.ts_setpt)\n"
        inputs += "Hold Time (minutes),  \(calculaterUserInputModel.ts_dt_setpt)\n"
        inputs += ", Additional Inputs,\n"
        inputs += "Time Step (hours),  \(calculaterUserInputModel.time_step),\n"
        inputs += "Heat Transfer Coefficient (W/m\u{00B2} K),  \(calculaterUserInputModel.h_freezing),\n"
        
        var data = inputs
        
        data += ", Output,\n"
        
        
        let header = "Time (hours), Shelf Temperature (\u{2103}), Product Temperature (\u{2103})\n"
        
        data += header
        
        for model in freezing {
            data += "\(String(format: "%.2f", model.time)), \(String(format: "%.2f", model.shelfTemperature)), \(String(format: "%.2f", model.productTemperature))\n"
        }
       
        let fileName = "freezing.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        do {
            try data.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            return path
        } catch {
            print("Error: Unable to create the CSV file.")
            return nil
        }
    }
    
}
