//
//  DesignSpaceSave.swift
//  LyoPronto
//

import SwiftUI

struct DesignSpaceSaveView: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(fetchRequest: DesignSpaceHistory.fetchHistory()) private var histories
    @FetchRequest(fetchRequest: DesignSpace.fetchAllSaves()) private var saves
    
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
    
    @ObservedObject var vm: DesignSpaceViewModel
    @StateObject var designSpaceModel: DesignSpaceModel
    
    @StateObject var outputVM = DesignSpaceOutputViewModel()
    
    @StateObject private var formDataModel = DSFormDataModel()
    
    var body: some View {
        VStack {
            DesignSpaceInputForm(designSpaceModel: designSpaceModel, dsFormDataModel: formDataModel)
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
                    isValidate = inputValidationsDS(for: designSpaceModel)
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
            DSCalculatorOutputView(calculaterUserInputModel: designSpaceModel)
        }
        .sheet(isPresented: $formDataModel.showDetail, content: {
            InfoPage(title: $formDataModel.selectedTitle)
        })
        .onAppear {
            hideTabBar = true
            tempName = vm.designSpace.name  ?? "Saved"
        }
        .navigationTitle(tempName)
        .navigationTitle(vm.designSpace.name ?? "Saved Input")
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
                            let TempName = vm.designSpace.name
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
            TextField("Rename?", text: $designSpaceModel.name)
            Button("Save",role: .destructive, action: {
                updateRecord(name: designSpaceModel.name)
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

extension DesignSpaceSaveView {
    
    private func transferToVM(useName: Bool = false, name: String = "") {
        vm.designSpace.id = UUID()
        vm.designSpace.date = Date.now
        vm.designSpace.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        if (useName) {
            vm.designSpace.name = name
        }
        else{
            vm.designSpace.name = designSpaceModel.name
        }
        vm.designSpace.av = designSpaceModel.av
        vm.designSpace.ap = designSpaceModel.ap
        vm.designSpace.vfill = designSpaceModel.vfill
        vm.designSpace.cSolid = designSpaceModel.cSolid
        vm.designSpace.cr_temp = designSpaceModel.cr_temp
        vm.designSpace.r0 = designSpaceModel.r0
        vm.designSpace.a1 = designSpaceModel.a1
        vm.designSpace.a2 = designSpaceModel.a2
        vm.designSpace.kc = designSpaceModel.kc
        vm.designSpace.kp = designSpaceModel.kp
        vm.designSpace.kd = designSpaceModel.kd
        vm.designSpace.ramp_rate = designSpaceModel.ramp_rate
        vm.designSpace.setpt = designSpaceModel.setpt
        vm.designSpace.ts_init_val = designSpaceModel.ts_init_val
        vm.designSpace.ts_ramp_rate = designSpaceModel.ts_ramp_rate
        vm.designSpace.ts_setpt = designSpaceModel.ts_setpt
        vm.designSpace.equip_a = designSpaceModel.equip_a
        vm.designSpace.equip_b = designSpaceModel.equip_b
        vm.designSpace.time_step = designSpaceModel.time_step
        vm.designSpace.n_vials = designSpaceModel.n_vials
        vm.objectWillChange.send()
    }
    
    private func updateRecord(name: String = "") {
        if (name.count >= 1){
            vm.designSpace.name = designSpaceModel.name
        }
        vm.designSpace.av = designSpaceModel.av
        vm.designSpace.ap = designSpaceModel.ap
        vm.designSpace.vfill = designSpaceModel.vfill
        vm.designSpace.cSolid = designSpaceModel.cSolid
        vm.designSpace.cr_temp = designSpaceModel.cr_temp
        vm.designSpace.r0 = designSpaceModel.r0
        vm.designSpace.a1 = designSpaceModel.a1
        vm.designSpace.a2 = designSpaceModel.a2
        vm.designSpace.kc = designSpaceModel.kc
        vm.designSpace.kp = designSpaceModel.kp
        vm.designSpace.kd = designSpaceModel.kd
        vm.designSpace.ramp_rate = designSpaceModel.ramp_rate
        vm.designSpace.setpt = designSpaceModel.setpt
        vm.designSpace.ts_init_val = designSpaceModel.ts_init_val
        vm.designSpace.ts_ramp_rate = designSpaceModel.ts_ramp_rate
        vm.designSpace.ts_setpt = designSpaceModel.ts_setpt
        vm.designSpace.equip_a = designSpaceModel.equip_a
        vm.designSpace.equip_b = designSpaceModel.equip_b
        vm.designSpace.time_step = designSpaceModel.time_step
        vm.designSpace.n_vials = designSpaceModel.n_vials
        vm.objectWillChange.send()
    }
    
}

