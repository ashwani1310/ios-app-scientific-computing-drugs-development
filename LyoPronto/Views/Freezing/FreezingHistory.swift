//
//  FreezingHistory.swift
//  LyoPronto
//

import SwiftUI

struct FreezingHistoryView: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false

    @State private var selectedPickerSegnment = 5
    @State private var presentAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var saveSuccessflyPresentAlert = false
    @State private var showWebView = false
    @State private var presentErrorAlert = false
    @State private var isValidate: Bool = false
    
    var isEditable: Bool = false
    
    @ObservedObject var vm: FreezingViewModel
    @StateObject var freezingModel: FreezingModel
    
    @State var historyDate: String = ""
    
    @StateObject private var outputVM = FreezingOutputViewModel()
    
    @State var showGraph: Bool = false
    
    @State var isShare: Bool = false
    @State var fileToShare = [Any]()
    
    @StateObject private var formDataModel = FreezingFormDataModel()
    
    var body: some View {
        VStack {
            FreezingInputForm(freezingModel: freezingModel, freezingFormDataModel: formDataModel, fromHistory: true, historyDate: historyDate)
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
                    isValidate = inputValidationsFreezing(for: freezingModel)
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
//                    vm.clearRun()
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
            FreezingCalculatorOutputView(calculaterUserInputModel: freezingModel)
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
            TextField("Enter name to save input", text: $freezingModel.name)
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

extension FreezingHistoryView {
    
    private func transferToVM() {
        vm.freezing.date = Date.now
        vm.freezing.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        vm.freezing.id = UUID()
        vm.freezing.name = freezingModel.name
        vm.freezing.av = freezingModel.av
        vm.freezing.ap = freezingModel.ap
        vm.freezing.vfill = freezingModel.vfill
        vm.freezing.cSolid = freezingModel.cSolid
        vm.freezing.cr_temp = freezingModel.cr_temp
        vm.freezing.tpr0 = freezingModel.tpr0
        vm.freezing.tf = freezingModel.tf
        vm.freezing.tn = freezingModel.tn
        vm.freezing.ts_init_val = freezingModel.ts_init_val
        vm.freezing.ts_ramp_rate = freezingModel.ts_ramp_rate
        vm.freezing.ts_setpt = freezingModel.ts_setpt
        vm.freezing.ts_dt_setpt = freezingModel.ts_dt_setpt
        vm.freezing.time_step = freezingModel.time_step
        vm.freezing.h_freezing = freezingModel.h_freezing
        vm.objectWillChange.send()
    }
    
}
