//
//  FreezingCalculator.swift
//  LyoPronto
//

import SwiftUI



class FreezingFormDataModel: ObservableObject {
    @Published var clearPreset: Bool = false
    @Published var showDetail: Bool = false
    @Published var selectedTitle: String = ""
    @Published var vialPresetTitle: String = DisplayNames.vialPresetTitle
    @Published var productPresetTitle: String = DisplayNames.productPresetTitle
    @Published var tshelfPresetTitle: String = DisplayNames.tshelfPresetTitle
    @Published var otherPresetTitle: String = DisplayNames.otherPresetTitle
}


struct FreezingInputForm: View {
    
    @ObservedObject var freezingModel: FreezingModel
    @ObservedObject var freezingFormDataModel: FreezingFormDataModel
    
    var fromHistory: Bool = false
    var historyDate: String = ""
    
    var isEditable: Bool = true

    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        List {
            if (fromHistory) {
                HStack {
                    Text("From")
                        .fontWeight(.bold)
                    Text(historyDate)
                }
            }
            vialView
            productView
            tshelfView
            additionalInputsView
        }
    }
}

extension FreezingInputForm {
    
    var vialView: some View {
        Section {
            Menu {
                ForEach (FreezingPresetKeys.vialKeys, id: \.self) { key in
                    Button(key, action: {
                        freezingFormDataModel.vialPresetTitle = key
                        updatePresets(type: DisplayNames.vial, preset: key)
                    })
                }
            } label: {
                Text(freezingFormDataModel.vialPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.av, editable: isEditable, text: $freezingModel.av)
                .keyboardType(.numbersAndPunctuation)
                .focused($isTextFieldFocused)
            FloatingTextfield(DisplayNames.ap, editable: isEditable, text: $freezingModel.ap)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.vfill, editable: isEditable, text: $freezingModel.vfill)
                .keyboardType(.numbersAndPunctuation)
            
        } header: {
            HStack {
                Text(DisplayNames.vial)
                Spacer()
                Button {
                    freezingFormDataModel.selectedTitle = DisplayNames.vial
                    freezingFormDataModel.showDetail = true
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    
    var productView: some View {
        Section {
            Menu {
                ForEach (FreezingPresetKeys.productKeys, id: \.self) { key in
                    Button(key, action: {
                        freezingFormDataModel.productPresetTitle = key
                        updatePresets(type: DisplayNames.product, preset: key)
                    })
                }
            } label: {
                Text(freezingFormDataModel.productPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.cSolid, editable: isEditable, text: $freezingModel.cSolid)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.tpr0, editable: isEditable, text: $freezingModel.tpr0)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.tf, editable: isEditable, text: $freezingModel.tf)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.tn, editable: isEditable, text: $freezingModel.tn)
                .keyboardType(.numbersAndPunctuation)
            
        } header: {
            HStack {
                Text(DisplayNames.product)
                Spacer()
                Button {
                    freezingFormDataModel.selectedTitle = DisplayNames.freezingProduct
                    freezingFormDataModel.showDetail = true
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    var tshelfView:some View {
        Section {
            Menu {
                ForEach (FreezingPresetKeys.tshelfKeys, id: \.self) { key in
                    Button(key, action: {
                        freezingFormDataModel.tshelfPresetTitle = key
                        updatePresets(type: DisplayNames.tshelf, preset: key)
                    })
                }
            } label: {
                Text(freezingFormDataModel.tshelfPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.ts_init_val, editable: isEditable, text: $freezingModel.ts_init_val)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.ts_ramp_rate, editable: isEditable, text:$freezingModel.ts_ramp_rate)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.ts_setpt, editable: isEditable, text:$freezingModel.ts_setpt)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.ts_dt_setpt, editable: isEditable, text: $freezingModel.ts_dt_setpt)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.tshelf)
                Spacer()
                Button {
                    freezingFormDataModel.selectedTitle = DisplayNames.tshelf
                    freezingFormDataModel.showDetail = true
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    var additionalInputsView: some View {
        Section {
            Menu {
                ForEach (FreezingPresetKeys.otherKeys, id: \.self) { key in
                    Button(key, action: {
                        freezingFormDataModel.otherPresetTitle = key
                        updatePresets(type: DisplayNames.other_inputs, preset: key)
                    })
                }
            } label: {
                Text(freezingFormDataModel.otherPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.time_step, editable: isEditable, text: $freezingModel.time_step)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.h_freezing, editable: isEditable, text: $freezingModel.h_freezing)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.other_inputs)
                Spacer()
            }
        }
    }
}


extension FreezingInputForm {
    
    func updatePresets(type: String, preset: String){
        
        if (type == DisplayNames.vial) {
            if let vialPreset = FreezingPresets.vialPresets[preset] {
                freezingModel.av = vialPreset.av
                freezingModel.ap = vialPreset.ap
                freezingModel.vfill = vialPreset.vfill
            }
        }
        else if (type == DisplayNames.product) {
            if let productPreset = FreezingPresets.productPresets[preset] {
                freezingModel.cSolid = productPreset.csolid
                freezingModel.tpr0 = productPreset.tpr0
                freezingModel.tf = productPreset.tf
                freezingModel.tn = productPreset.tn
            }
        }
        else if (type == DisplayNames.tshelf) {
            if let tshelfPreset = FreezingPresets.shelfTemperaturePresets[preset] {
                freezingModel.ts_init_val = tshelfPreset.init_val
                freezingModel.ts_ramp_rate = tshelfPreset.ramp_rate
                freezingModel.ts_setpt = tshelfPreset.setpt
                freezingModel.ts_dt_setpt = tshelfPreset.dt_setpt
            }
        }
        else if (type == DisplayNames.other_inputs) {
            if let otherPreset = FreezingPresets.otherPresets[preset] {
                freezingModel.time_step = otherPreset.time_step
                freezingModel.h_freezing = otherPreset.h_freezing
            }
        }
    }
}


struct FreezingRoot: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(fetchRequest: FreezingHistory.fetchHistory()) private var histories
    @FetchRequest(fetchRequest: Freezing.fetchAllSaves()) private var saves
    
    @State private var presentAlert = false
    @State private var presentErrorAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var showWebView = false
    @State private var isValidate: Bool = false
    @State var presetMenuTitle: String = "Preset Inputs"
    
    @State var showHistory: Bool = false
    @State var showGraph: Bool = false
    @State var showloader: Bool = false
    
    @ObservedObject var vm: FreezingViewModel
    @StateObject var freezingModel = FreezingModel()
    
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
                        saveCurrentRunToHistory()
                        vm.newContext()
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
                    clearCurrent()
                    clearPresets()
                } label: {
                    Image(systemName: "trash")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 20)
                       .foregroundColor(Color.red)
                }
                .padding(.trailing)
            }
            .frame(height: 50)
          }
         .fullScreenCover(isPresented: $showGraph) {
             FreezingCalculatorOutputView(calculaterUserInputModel: freezingModel)
         }
         .fullScreenCover(isPresented: $showHistory, content: {
             FreezingHistoryRootView()
         })
         .sheet(isPresented: $formDataModel.showDetail, content: {
             InfoPage(title: $formDataModel.selectedTitle)
         })
         .onAppear {
             hideTabBar = true
         }
         .navigationTitle("Freezing")
         .navigationBarBackButtonHidden(true)
         .navigationBarItems(leading:
             Button(action: {
                 dismiss() // Wrap the dismiss() function call in a closure
             }) {
                 HStack(spacing: 2) {
                     Image(systemName: "chevron.left")
                     Text(" Back")
                 }
             }
         )
         .toolbar(hideTabBar ? .hidden : .visible , for: .tabBar)
         .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                  Menu {
                      Button("Save Input", action: {
                          presentAlert = true
                      })
                      Button("View Saved/History", action: {
                          showHistory = true
                      })
                  } label: {
                      Image(systemName: "line.horizontal.3")
                         .imageScale(.large)
                  }
              }
          }
         .contentShape(Rectangle())
//         .gesture(
//           DragGesture(coordinateSpace: .local)
//             .onEnded { value in
//               if value.translation.width > .zero
//                   && value.translation.height > -30
//                   && value.translation.height < 30 {
//                 dismiss()
//               }
//             }
//         )
         .alert("Save Input", isPresented: $presentAlert, actions: {
             TextField("Enter name to save input", text: $freezingModel.name)
             Button("Save",role: .destructive, action: {
                 tranferToVM()
                 vm.freezing.date = Date.now
                 vm.freezing.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
                 vm.freezing.id = UUID()
                 do {
                     try vm.saveRun()
                 } catch {
                     print("Error saving history: \(error)")
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

extension FreezingRoot {
    
    func clearPresets(){
        formDataModel.vialPresetTitle = DisplayNames.vialPresetTitle
        formDataModel.productPresetTitle = DisplayNames.productPresetTitle
        formDataModel.tshelfPresetTitle = DisplayNames.tshelfPresetTitle
        formDataModel.otherPresetTitle = DisplayNames.otherPresetTitle
    }
}

extension FreezingRoot {
    
    private func tranferToVM() {
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
    
    private func clearCurrent() {
        freezingModel.av = ""
        freezingModel.ap = ""
        freezingModel.vfill = ""
        freezingModel.cSolid = ""
        freezingModel.cr_temp = ""
        freezingModel.tpr0 = ""
        freezingModel.tf = ""
        freezingModel.tn = ""
        freezingModel.ts_init_val = ""
        freezingModel.ts_ramp_rate = ""
        freezingModel.ts_setpt = ""
        freezingModel.ts_dt_setpt = ""
        freezingModel.time_step = ""
        freezingModel.h_freezing = ""
    }
    
    private func saveCurrentRunToHistory() {
        vm.objectWillChange.send()
        vm.freezingHistory.date = Date.now
        vm.freezingHistory.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        vm.freezingHistory.id = UUID()
        vm.freezingHistory.av = freezingModel.av
        vm.freezingHistory.ap = freezingModel.ap
        vm.freezingHistory.vfill = freezingModel.vfill
        vm.freezingHistory.cSolid = freezingModel.cSolid
        vm.freezingHistory.cr_temp = freezingModel.cr_temp
        vm.freezingHistory.tpr0 = freezingModel.tpr0
        vm.freezingHistory.tf = freezingModel.tf
        vm.freezingHistory.tn = freezingModel.tn
        vm.freezingHistory.ts_init_val = freezingModel.ts_init_val
        vm.freezingHistory.ts_ramp_rate = freezingModel.ts_ramp_rate
        vm.freezingHistory.ts_setpt = freezingModel.ts_setpt
        vm.freezingHistory.ts_dt_setpt = freezingModel.ts_dt_setpt
        vm.freezingHistory.time_step = freezingModel.time_step
        vm.freezingHistory.h_freezing = freezingModel.h_freezing
        vm.objectWillChange.send()
        do {
            try vm.saveHistory()
            print("saved run")
        } catch {
            print("Error saving run: \(error)")
        }
    }
    
}


func inputValidationsFreezing(for freezingModel: FreezingModel) -> Bool {
    let av: Float = Float(freezingModel.av) ?? -1.0
    let ap: Float = Float(freezingModel.ap) ?? -1.0
    let vfill: Float = Float(freezingModel.vfill) ?? -1.0
    let cSolid: Float = Float(freezingModel.cSolid) ?? -1.0
    let tpr0: Float = Float(freezingModel.tpr0) ?? -1000.0
    let tf: Float = Float(freezingModel.tf) ?? 1.0
    let tn: Float = Float(freezingModel.tn) ?? 1.0
    let ts_init_val : Float = Float(freezingModel.ts_init_val) ?? 101.0
    let ts_ramp_rate : Float = Float(freezingModel.ts_ramp_rate) ?? -1.0
    let time_step : Float = Float(freezingModel.time_step) ?? 0.0
    let h_freezing : Float = Float(freezingModel.h_freezing) ?? -1000.0
    
    
    if (freezingModel.ts_setpt.contains(",")) {
        let ts_setpt_list = freezingModel.ts_setpt.split(separator: ",")
        for val in ts_setpt_list {
            if let ts_setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                if (ts_setpt_val < -60.0 || ts_setpt_val > 60.0){
                    return false
                }
            } else {
                return false
            }
        }
    } else {
        if let ts_setpt = Double(freezingModel.ts_setpt) {
            if (ts_setpt < -60.0 || ts_setpt > 60.0){
                return false
            }
        }
        else{
            return false
        }
    }
    
    if (freezingModel.ts_dt_setpt.contains(",")) {
        let dt_setpt_list = freezingModel.ts_dt_setpt.split(separator: ",")
        for val in dt_setpt_list {
            if let dt_setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                if (dt_setpt_val < 0.0){
                    return false
                }
            } else {
                return false
            }
        }
    } else {
        if let dt_setpt = Double(freezingModel.ts_dt_setpt) {
            if (dt_setpt < 0.0){
                return false
            }
        }
        else{
            return false
        }
    }
    
    
    if av > 0 &&
        ap > 0 &&
        vfill > 0.0 &&
        cSolid >= 0.0 &&
        tpr0 >= -999.0 &&
        tf <= 0.0 &&
        tn <= 0.0 &&
        ts_init_val >= -100 && ts_init_val <= 100 &&
        ts_ramp_rate >= 0 &&
        time_step > 0.0 &&
        h_freezing >= -999.0 {
        return true
    } else {
        return false
    }
}

