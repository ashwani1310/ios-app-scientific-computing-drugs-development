//
//  testviewcalculator.swift
//  LyoPronto
//


import SwiftUI

struct PrimaryDryHistoryView: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false

    @State private var selectedPickerSegnment = 5
    @State private var presentAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var saveSuccessflyPresentAlert = false
    @State private var showWebView = false
    @State private var presentErrorAlert = false
    @State private var isValidate: Bool = false
    
    @ObservedObject var vm: PrimaryDryViewModel
    @StateObject var pdModel: PDModel
    
    @State var historyDate: String = ""
    
    @StateObject private var outputVM = PrimaryDryOutputViewModel()
    
    @State var showGraph: Bool = false
    
    @State var isShare: Bool = false
    @State var fileToShare = [Any]()
    
    @StateObject private var formDataModel = PDFormDataModel()
    
    
    var body: some View {
        VStack {
            PrimaryDryInputForm(pdModel: pdModel, pdFormDataModel: formDataModel, fromHistory: true, historyDate: historyDate)
            HStack(alignment: .center) {
                Button {
                    
                } label: {
                    Image(systemName: "link")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 20)
                       .foregroundColor(Color.red)
                }
                .padding(.trailing)
                .opacity(0)
                Spacer()
                Button {
                    isValidate = inputValidationsPD(for: pdModel)
                    if isValidate {
                        presentErrorAlert = false
                        showGraph = true
                    } else {
                        presentErrorAlert = true
                    }
                } label: {
                    Image(systemName: "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 20)
                       .foregroundColor(Color.red)
                }
                .padding(.trailing)
                .opacity(0)
           }
           .frame(height: 50)
         }
        .fullScreenCover(isPresented: $showGraph) {
            CalculatorOutputView(calculaterUserInputModel: pdModel)
        }
        .sheet(isPresented: $formDataModel.showDetail, content: {
            InfoPage(title: $formDataModel.selectedTitle)
        })
        .onAppear {
            hideTabBar = true
        }
        .toolbar(hideTabBar ? .hidden : .visible , for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               Button("Save") {
                     presentAlert = true
                 }
             }
        }
        .navigationTitle("History")
        .alert("Save Input", isPresented: $presentAlert, actions: {
            TextField("Enter name to save input", text: $pdModel.name)
            Button("Save", role: .destructive, action: {
                transferToVM()
                do {
                    try vm.saveRun()
                } catch {
                    print("Error saving: \(error)")
                }
                vm.newContext()
            })
            Button("Cancel", role: .cancel, action: {
                saveInputTextFieldStr = ""
            })
        })
        .alert(isPresented: $presentErrorAlert) {
            Alert(title: Text("Invalid Inputs"), message: Text("Click on the info button next to every field to read about allowed values."), dismissButton: .default(Text("Got it!")))
        }
    }
}

extension PrimaryDryHistoryView {
    
    private func transferToVM() {
        vm.primaryDry.date = Date.now
        vm.primaryDry.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        vm.primaryDry.id = UUID()
        vm.primaryDry.name = pdModel.name
        vm.primaryDry.av = pdModel.av
        vm.primaryDry.ap = pdModel.ap
        vm.primaryDry.vfill = pdModel.vfill
        vm.primaryDry.cSolid = pdModel.cSolid
        vm.primaryDry.cr_temp = pdModel.cr_temp
        vm.primaryDry.r0 = pdModel.r0
        vm.primaryDry.a1 = pdModel.a1
        vm.primaryDry.a2 = pdModel.a2
        vm.primaryDry.kc = pdModel.kc
        vm.primaryDry.kp = pdModel.kp
        vm.primaryDry.kd = pdModel.kd
        vm.primaryDry.ramp_rate = pdModel.ramp_rate
        vm.primaryDry.setpt = pdModel.setpt
        vm.primaryDry.dt_setpt = pdModel.dt_setpt
        vm.primaryDry.min = pdModel.min
        vm.primaryDry.max = pdModel.max
        vm.primaryDry.ts_init_val = pdModel.ts_init_val
        vm.primaryDry.ts_ramp_rate = pdModel.ts_ramp_rate
        vm.primaryDry.ts_setpt = pdModel.ts_setpt
        vm.primaryDry.ts_dt_setpt = pdModel.ts_dt_setpt
        vm.primaryDry.ts_min = pdModel.ts_min
        vm.primaryDry.ts_max = pdModel.ts_max
        vm.primaryDry.time_step = pdModel.time_step
        vm.primaryDry.kv_known = pdModel.kv_known
        vm.primaryDry.from = pdModel.from
        vm.primaryDry.to = pdModel.to
        vm.primaryDry.step = pdModel.step
        vm.primaryDry.drying_time = pdModel.drying_time
        vm.objectWillChange.send()
    }
    
}
