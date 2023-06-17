//
//  testviewcalculator.swift
//  LyoPronto
//


import SwiftUI

struct PrimaryDrySaveView: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var selectedPickerSegnment = 5
    @State private var presentAlert = false
    @State private var presentErrorAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var saveSuccessflyPresentAlert = false
    @State private var showWebView = false
    @State private var isValidate: Bool = false
    @State private var copyInt = 0
    
    @State private var renamed = false
    @State private var copyCreated = false
    
    @State var showGraph: Bool = false
    
    @State var tempName: String = ""
    
    
    @ObservedObject var vm: PrimaryDryViewModel
    @StateObject var pdModel: PDModel
    
    @StateObject private var outputVM = PrimaryDryOutputViewModel()
    
    @StateObject private var formDataModel = PDFormDataModel()
    
    var body: some View {
        VStack {
            PrimaryDryInputForm(pdModel: pdModel, pdFormDataModel: formDataModel)
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
            CalculatorOutputView(calculaterUserInputModel: pdModel)
        }
        .sheet(isPresented: $formDataModel.showDetail, content: {
            InfoPage(title: $formDataModel.selectedTitle)
        })
        .onAppear {
            hideTabBar = true
            tempName = vm.primaryDry.name ?? "Saved"
        }
        .navigationTitle(tempName)
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
                            let TempName = vm.primaryDry.name
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
            TextField("Rename?", text: $pdModel.name)
            Button("Save",role: .destructive, action: {
                updateRecord(name: pdModel.name)
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


extension PrimaryDrySaveView {
    
    private func transferToVM(useName: Bool = false, name: String = "") {
        vm.primaryDry.id = UUID()
        vm.primaryDry.date = Date.now
        vm.primaryDry.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        if (useName) {
            vm.primaryDry.name = name
        }
        else{
            vm.primaryDry.name = pdModel.name
        }
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
        vm.primaryDry.ts_max = pdModel.ts_max
        vm.primaryDry.ts_min = pdModel.ts_min
        vm.primaryDry.time_step = pdModel.time_step
        vm.primaryDry.kv_known = pdModel.kv_known
        vm.primaryDry.from = pdModel.from
        vm.primaryDry.to = pdModel.to
        vm.primaryDry.step = pdModel.step
        vm.primaryDry.drying_time = pdModel.drying_time
        vm.objectWillChange.send()
    }
    
    
    private func updateRecord(name: String = "") {
        if (name.count >= 1){
            vm.primaryDry.name = pdModel.name
        }
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
        vm.primaryDry.ts_max = pdModel.ts_max
        vm.primaryDry.ts_min = pdModel.ts_min
        vm.primaryDry.time_step = pdModel.time_step
        vm.primaryDry.kv_known = pdModel.kv_known
        vm.primaryDry.from = pdModel.from
        vm.primaryDry.to = pdModel.to
        vm.primaryDry.step = pdModel.step
        vm.primaryDry.drying_time = pdModel.drying_time
        vm.objectWillChange.send()
    }
    
}

