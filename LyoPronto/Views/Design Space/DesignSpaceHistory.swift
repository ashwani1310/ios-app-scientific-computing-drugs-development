//
//  DesignSpaceHistory.swift
//  LyoPronto
//

import SwiftUI

struct DesignSpaceHistoryView: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false

    @State private var presentAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var saveSuccessflyPresentAlert = false
    @State private var showWebView = false
    @State private var presentErrorAlert = false
    @State private var isValidate: Bool = false
    
    @ObservedObject var vm: DesignSpaceViewModel
    @StateObject var designSpaceModel: DesignSpaceModel
    
    @State var historyDate: String = ""
    
    @StateObject var outputVM = DesignSpaceOutputViewModel()
    
    @State var showGraph: Bool = false
    
    @State var isShare: Bool = false
    @State var fileToShare = [Any]()
    
    @StateObject private var formDataModel = DSFormDataModel()
    
    var body: some View {
        VStack {
            DesignSpaceInputForm(designSpaceModel: designSpaceModel, dsFormDataModel: formDataModel, fromHistory: true, historyDate: historyDate)
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
            TextField("Enter name to save input", text: $designSpaceModel.name)
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


extension DesignSpaceHistoryView {
    
    private func transferToVM() {
        vm.designSpace.date = Date.now
        vm.designSpace.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        vm.designSpace.id = UUID()
        vm.designSpace.name = designSpaceModel.name
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
