//
//  DesignSpaceCalculatorView.swift
//  LyoPronto
//

import Foundation
import SwiftUI




struct DSCalculatorOutputView: View {
    
    @StateObject private var vm = DesignSpaceOutputViewModel()
    
    @State private var selectedPickerSegnment = 0
    @State private var selectedChart = 0
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var calculaterUserInputModel: DesignSpaceModel
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
                        if let url = shareDesignSpaceCSV(vm.getTableData()) {
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
                if(!vm.designSpaceResultReady) {
                    GraphLoaderAnimation()
                } else {
                     if(selectedPickerSegnment == 0) {
                         Picker("", selection: $selectedChart) {
                             Text("Sublimation Flux").tag(0)
                             Text("Temperatures").tag(1)
                             Text("Drying Time").tag(2)
                         }
                         .pickerStyle(.segmented)
                         .padding(.all)
                         
                         if (selectedChart == 1) {
                             DSTempChartView(designSpaceModel: vm.getGraphData().0, addValues: vm.getGraphData().1)
                         }
                         else if (selectedChart == 2) {
                             DSDryingChartView(designSpaceModel: vm.getGraphData().0, addValues: vm.getGraphData().1)
                         }
                         else  {
                             DSSublimationChartView(designSpaceModel: vm.getGraphData().0, addValues: vm.getGraphData().1)
                         }
                         
                    } else {
                        DesignSpaceDataTableView(data: vm.getTableData())
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
    
    private func shareDesignSpaceCSV(_ designSpace: [DSTableOutputModel]) -> URL? {
        
        var inputs = ", , , Input, , , ,\n"
        inputs += ", , , Vial, , , \n"
        inputs += "Vial Area (cm\u{00B2}),  \(calculaterUserInputModel.av), , , , , ,\n"
        inputs += "Product Area (cm\u{00B2}),  \(calculaterUserInputModel.ap), , , , , ,\n"
        inputs += "Fill Volume (mL),  \(calculaterUserInputModel.vfill), , , , , ,\n"
        inputs += ", , , Product, , , ,\n"
        inputs += "Solid Content (%w/v),  \(calculaterUserInputModel.cSolid), , , , , ,\n"
        inputs += "Critical Product Temperature (\u{2103}),  \(calculaterUserInputModel.cr_temp), , , , , ,\n"
        inputs += "R\u{2080} (cm\u{00B2}-hr-Torr/g),  \(calculaterUserInputModel.r0), , , , , ,\n"
        inputs += "A\u{2081} (cm-hr-Torr/g),  \(calculaterUserInputModel.a1), , , , , ,\n"
        inputs += "A\u{2082} (1/cm),  \(calculaterUserInputModel.a2), , , , , ,\n"
        inputs += ", , , Vial Heat Transfer, , , ,\n"
        inputs += "K\u{1D04} (Cal-K/cm\u{00B2}-s),  \(calculaterUserInputModel.kc), , , , , ,\n"
        inputs += "K\u{1D18} (Cal-K/cm\u{00B2}-s-Torr),  \(calculaterUserInputModel.kp), , , , , ,\n"
        inputs += "K\u{1D05} (1/Torr),  \(calculaterUserInputModel.kd), , , , , ,\n"
        inputs += ", , , Chamber Pressure, , , ,\n"
        inputs += "Ramp Rate (Torr/minutes),  \(calculaterUserInputModel.ramp_rate), , , , , ,\n"
        inputs += "Setpoint (Torr),  \(calculaterUserInputModel.setpt)\n"
        inputs += ", , , Shelf Temperature, , , ,\n"
        inputs += "Initial Shelf Temperature (\u{2103}),  \(calculaterUserInputModel.ts_init_val), , , , , ,\n"
        inputs += "Ramp Rate (\u{2103}/minutes),  \(calculaterUserInputModel.ts_ramp_rate), , , , , ,\n"
        inputs += "Setpoint (\u{2103}),  \(calculaterUserInputModel.ts_setpt)\n"
        inputs += ", , , Equipment Capability, , , ,\n"
        inputs += "a (Slope),  \(calculaterUserInputModel.equip_a), , , , , ,\n"
        inputs += "b (Intercept),  \(calculaterUserInputModel.equip_b), , , , , ,\n"
        inputs += ", , , Additional Inputs, , , ,\n"
        inputs += "Time Step (hours),  \(calculaterUserInputModel.time_step), , , , , ,\n"
        inputs += "Number of Vials,  \(calculaterUserInputModel.n_vials), , , , , ,\n"
        
        var data = inputs
        
        data += ", , , Output, , , , \n"
        
        let header = "Type, Value, Chamber Pressure (mTorr), Maximum Product Temperature (\u{2103}), Drying Time (hours), Average Sublimation Flux (kg/hr/m\u{00B2}), Maximum/Minimum Sublimation Flux (kg/hr/m\u{00B2}), Final Sublimation Flux (kg/hr/m\u{00B2})\n"
        
        data += header
        
        for model in designSpace {
            data += "\(model.type), \(model.value), \(String(format: "%.2f", model.pressure)), \(String(format: "%.2f", model.temperature)), \(String(format: "%.2f", model.time)), \(String(format: "%.2f", model.sublimationAvg)), \(String(format: "%.2f", model.sublimationMax)), \(String(format: "%.2f", model.sublimationFinal))\n"
        }
       
        let fileName = "designspace.csv"
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

