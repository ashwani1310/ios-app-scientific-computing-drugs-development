//
//  PDCalculatorView.swift
//  LyoPronto
//

import Foundation
import SwiftUI

struct GraphLoaderAnimation: View {
    @State var isAtMaxScale = false
    
    private let animation = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    private let maxScale: CGFloat = 1.5
    
    var body: some View {
        VStack{
            Spacer()
            Text("Processing")
                .font(.custom("Avenir", size: 16))
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.blue)
                .frame(width: UIScreen.main.bounds.width / 2, height: 3)
                .scaleEffect(CGSize(width: isAtMaxScale ? maxScale : 0.01, height: 1.0))
                .onAppear(perform: {
                    withAnimation(animation) {
                        self.isAtMaxScale.toggle()
                    }
                })
            Spacer()
        }
    }
}


struct CalculatorOutputView: View {
    
    @StateObject private var vm = PrimaryDryOutputViewModel()
    
    @State private var selectedPickerSegnment = 0
    @State private var selectedChart = 0
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var calculaterUserInputModel: PDModel

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
                        if let url = sharePrimaryDryCSV(vm.getPrimaryDryResult().1) {
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
                .sheet(item: $shareFile, onDismiss: {loadingView = false}) { shareFile in
                    ShareSheet(url: shareFile.filePath)
                }
                if($vm.primaryDryCalculatorResult.isEmpty) {
                    GraphLoaderAnimation()
                } else {
                    if(selectedPickerSegnment == 0) {
                        Picker("", selection: $selectedChart) {
                            Text("Percent Dried").tag(0)
                            Text("Temperatures").tag(1)
                            Text("Sublimation Flux").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding(.all)
                        
                        if (selectedChart == 0) {
                            PercentDriedLineChartView(primaryDryingModel: vm.getPrimaryDryResult().0, rangeValues: vm.getPrimaryDryResult().2)
                        }
                        else if (selectedChart == 1) {
                            TempratureChartView(primaryDryingModel: vm.getPrimaryDryResult().0, rangeValues: vm.getPrimaryDryResult().2, criticalTemp: Double(calculaterUserInputModel.cr_temp) ?? 0.0)
                        }
                        else  {
                            SublimationFluxView(primaryDryingModel: vm.getPrimaryDryResult().0, rangeValues: vm.getPrimaryDryResult().2)
                        }
                        
                    } else {
                        DataTableView(data: vm.getPrimaryDryResult().1)
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
    
    private func sharePrimaryDryCSV(_ pdModelArray: [PDOutputModel]) -> URL? {
        
        var inputs = ", , , Input, , ,\n"
        inputs += ", , , Vial, , ,\n"
        inputs += "Vial Area (cm\u{00B2}),  \(calculaterUserInputModel.av), , , , ,\n"
        inputs += "Product Area (cm\u{00B2}),  \(calculaterUserInputModel.ap), , , , ,\n"
        inputs += "Fill Volume (mL),  \(calculaterUserInputModel.vfill), , , , ,\n"
        inputs += ", , , Product, , , \n"
        inputs += "Solid Content (%w/v),  \(calculaterUserInputModel.cSolid), , , , , \n"
        inputs += "Critical Product Temperature (\u{2103}),  \(calculaterUserInputModel.cr_temp), , , , ,\n"
        inputs += "R\u{2080} (cm\u{00B2}-hr-Torr/g),  \(calculaterUserInputModel.r0), , , , ,\n"
        inputs += "A\u{2081} (cm-hr-Torr/g),  \(calculaterUserInputModel.a1), , , , ,\n"
        inputs += "A\u{2082} (1/cm),  \(calculaterUserInputModel.a2), , , , ,\n"
        inputs += ", , , Vial Heat Transfer, , ,\n"
        
        if (calculaterUserInputModel.kv_known){
            inputs += "K\u{1D04} (Cal-K/cm\u{00B2}-s),  \(calculaterUserInputModel.kc), , , , ,\n"
            inputs += "K\u{1D18} (Cal-K/cm\u{00B2}-s-Torr),  \(calculaterUserInputModel.kp), , , , ,\n"
            inputs += "K\u{1D05} (1/Torr),  \(calculaterUserInputModel.kd), , , , ,\n"
        } else {
            inputs += "From,  \(calculaterUserInputModel.from), , , , ,\n"
            inputs += "To,  \(calculaterUserInputModel.to), , , , ,\n"
            inputs += "Step,  \(calculaterUserInputModel.step), , , , ,\n"
            inputs += "Primary Drying Time (hours),  \(calculaterUserInputModel.drying_time), , , , ,\n"
        }
        
        inputs += ", , , Chamber Pressure, , ,\n"
        inputs += "Ramp Rate (Torr/minutes),  \(calculaterUserInputModel.ramp_rate), , , , ,\n"
        inputs += "Setpoint (Torr),  \(calculaterUserInputModel.setpt)\n"
        inputs += "Hold Time (minutes),  \(calculaterUserInputModel.dt_setpt)\n"
        inputs += ", , , Shelf Temperature, , , \n"
        inputs += "Initial Shelf Temperature (\u{2103}),  \(calculaterUserInputModel.ts_init_val), , , , ,\n"
        inputs += "Ramp Rate (\u{2103}/minutes),  \(calculaterUserInputModel.ts_ramp_rate), , , , ,\n"
        inputs += "Setpoint (\u{2103}),  \(calculaterUserInputModel.ts_setpt)\n"
        inputs += "Hold Time (minutes),  \(calculaterUserInputModel.ts_dt_setpt)\n"
        inputs += ", , , Additional Inputs, , , \n"
        inputs += "Time Step (hours),  \(calculaterUserInputModel.time_step), , , , ,\n"
        
        var data = inputs
        
        data += ", , , Output, , , \n"
        
        let header = "Time (hr),Sublimation Temperature (\u{2103}),Vial Bottom Temperature (\u{2103}),Shelf Temperature (\u{2103}),Chamber Pressure (mTorr),Sublimation Flux (kg/hr/m\u{00B2}),Percent Dried\n"
        
        data += header
        
        for pmModel in pdModelArray {
            data += "\(String(format: "%.2f", pmModel.time)), \(String(format: "%.2f", pmModel.sublimationTemprature)), \(String(format: "%.2f", pmModel.vialBottomTemprature)), \(String(format: "%.2f", pmModel.shelfTemperature)), \(String(format: "%.2f", pmModel.chamberPressure)), \(String(format: "%.2f", pmModel.sublimationFlux)), \(String(format: "%.2f", pmModel.driedPercent))\n"
        }
       
        let fileName = "primarydry.csv"
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
