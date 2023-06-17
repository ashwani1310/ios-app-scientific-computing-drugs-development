//
//  FreezingSave.swift
//  LyoPronto
//

import SwiftUI

struct FreezingSaveView: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(fetchRequest: FreezingHistory.fetchHistory()) private var histories
    @FetchRequest(fetchRequest: Freezing.fetchAllSaves()) private var saves
    
    @State private var selectedPickerSegnment = 5
    @State private var presentAlert = false
    @State private var presentErrorAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var saveSuccessflyPresentAlert = false
    @State private var showWebView = false
    @State private var isValidate: Bool = false
    @State private var copyInt = 0
    
    @State var showGraph: Bool = false
    
    @State var isShare: Bool = false
    @State var fileToShare = [Any]()
    
    @State var tempName: String = ""
    
    @ObservedObject var vm: FreezingViewModel
    @StateObject var freezingModel: FreezingModel
    
    @StateObject var outputVM = FreezingOutputViewModel()
    
    @StateObject private var formDataModel = FreezingFormDataModel()
    
    var body: some View {
        VStack {
            FreezingInputForm(freezingModel: freezingModel, freezingFormDataModel: formDataModel)
            HStack(alignment: .center) {
                Spacer()
                    .frame(width: 10)
                Link(destination: URL(string: "https://link.springer.com/article/10.1208/s12249-019-1532-7")!, label: {
                    Label("LyoPRONTO", systemImage: "doc.plaintext")
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .trailing)
                        .labelStyle(AdaptiveLabelStyle())
                })
                Spacer()
                    .frame(width: horizontalSizeClass == .compact ? 85 : UIScreen.main.bounds.width/3.0)
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
            tempName = vm.freezing.name  ?? "Saved"
        }
        .navigationTitle(tempName)
        .navigationTitle(vm.freezing.name ?? "Saved Input")
        .toolbar(hideTabBar ? .hidden : .visible , for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Actions") {
                    VStack {
                        Button {
                            updateRecord()
                            do {
                                try vm.saveRun()
                            } catch {
                                print("Error saving: \(error)")
                            }
                            saveSuccessflyPresentAlert = true
                        } label: {
                            Text("Save")
                        }
                        Button {
                            presentAlert = true
                        } label: {
                            Text("Rename")
                        }
                        Button {
                            let TempName = vm.freezing.name
                            vm.newContext()
                            copyInt += 1
                            transferToVM(useName: true, name: (TempName! + " Copy " + "\(copyInt)"))
                            do {
                                try vm.saveRun()
                            } catch {
                                print("Error creating a copy: \(error)")
                            }
                            vm.newContext()
                        } label: {
                            Text("Make a copy")
                        }
                    }
                }
               
            }
        }
        .alert("Rename Input", isPresented: $presentAlert, actions: {
            TextField("Rename?", text: $freezingModel.name)
            Button("Save",role: .destructive, action: {
                updateRecord(name: freezingModel.name)
                do {
                    try vm.saveRun()
                } catch {
                    print("Error renaming: \(error)")
                }
            })
            Button("Cancel", role: .cancel, action: {
            })
        }, message: {
            Text("Go to the previous screen to see the updated name in saved list.")
        })
        .alert("Updated Successfully!", isPresented: $saveSuccessflyPresentAlert) {
            Button("OK", role: .cancel) {
                saveSuccessflyPresentAlert = false
            }
        }
        .alert(isPresented: $presentErrorAlert) {
            Alert(title: Text("Invalid Inputs"), message: Text("Click on the info button next to every field to read about allowed values."), dismissButton: .default(Text("Got it!")))
        }
    }
}

extension FreezingSaveView {
    
    private func transferToVM(useName: Bool = false, name: String = "") {
        vm.freezing.id = UUID()
        vm.freezing.date = Date.now
        vm.freezing.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        if (useName) {
            vm.freezing.name = name
        }
        else{
            vm.freezing.name = freezingModel.name
        }
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
    
    private func updateRecord(name: String = "") {
        if (name.count >= 1){
            vm.freezing.name = freezingModel.name
        }
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
