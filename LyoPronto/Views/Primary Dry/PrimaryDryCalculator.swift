//
//  testviewcalculator.swift
//  LyoPronto
//

import SwiftUI


struct AdaptiveLabelStyle: LabelStyle {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  func makeBody(configuration: Configuration) -> some View {
    if horizontalSizeClass == .compact {
      VStack {
        configuration.icon
        configuration.title
      }
    } else {
      Label(configuration)
    }
  }
}


class PDFormDataModel: ObservableObject {
    @Published var clearPreset: Bool = false
    @Published var showDetail: Bool = false
    @Published var selectedTitle: String = ""
    @Published var vialPresetTitle: String = DisplayNames.vialPresetTitle
    @Published var productPresetTitle: String = DisplayNames.productPresetTitle
    @Published var htPresetTitle: String = DisplayNames.htPresetTitle
    @Published var pchamberPresetTitle: String = DisplayNames.pchamberPresetTitle
    @Published var tshelfPresetTitle: String = DisplayNames.tshelfPresetTitle
    @Published var eqpCapPresetTitle: String = DisplayNames.eqpCapPresetTitle
    @Published var otherPresetTitle: String = DisplayNames.otherPresetTitle
}


struct PrimaryDryInputForm: View {
    
    @ObservedObject var pdModel: PDModel
    @ObservedObject var pdFormDataModel: PDFormDataModel
    
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
            htView
            pcHamberView
            tshelfView
            additionalInputsView
        }
    }
}

extension PrimaryDryInputForm {
    
    var vialView: some View {
        Section {
            Menu {
                ForEach (PrimaryDryingPresetKeys.vialKeys, id: \.self) { key in
                    Button(key, action: {
                        pdFormDataModel.vialPresetTitle = key
                        updatePresets(type: DisplayNames.vial, preset: key)
                    })
                }
            } label: {
                Text(pdFormDataModel.vialPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.av, editable: isEditable, text: $pdModel.av)
                .keyboardType(.numbersAndPunctuation)
                .focused($isTextFieldFocused)
            FloatingTextfield(DisplayNames.ap, editable: isEditable, text: $pdModel.ap)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.vfill, editable: isEditable, text: $pdModel.vfill)
                .keyboardType(.numbersAndPunctuation)
            
        } header: {
            HStack {
                Text(DisplayNames.vial)
                Spacer()
                Button {
                    pdFormDataModel.selectedTitle = DisplayNames.vial
                    pdFormDataModel.showDetail = true
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
                ForEach (PrimaryDryingPresetKeys.productKeys, id: \.self) { key in
                    Button(key, action: {
                        pdFormDataModel.productPresetTitle = key
                        updatePresets(type: DisplayNames.product, preset: key)
                    })
                }
            } label: {
                Text(pdFormDataModel.productPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.cSolid, editable: isEditable, text: $pdModel.cSolid)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.cr_temp, editable: isEditable, text: $pdModel.cr_temp)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.r0, editable: isEditable, text: $pdModel.r0)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.a1, editable: isEditable, text: $pdModel.a1)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.a2, editable: isEditable, text: $pdModel.a2)
                .keyboardType(.numbersAndPunctuation)
            
        } header: {
            HStack {
                Text(DisplayNames.product)
                Spacer()
                Button {
                    pdFormDataModel.selectedTitle = DisplayNames.product
                    pdFormDataModel.showDetail = true
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
    
    var htView: some View {
        Section {
            Toggle("Coefficients Known", isOn: $pdModel.kv_known)
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .foregroundColor(.accentColor)
            
            if (pdModel.kv_known) {
                
                Menu {
                    ForEach (PrimaryDryingPresetKeys.heatTransferKeys, id: \.self) { key in
                        Button(key, action: {
                            pdFormDataModel.htPresetTitle = key
                            updatePresets(type: DisplayNames.ht, preset: key)
                        })
                    }
                } label: {
                    Text(pdFormDataModel.htPresetTitle).frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .font(.headline)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
                .contentShape(Rectangle())
                
                FloatingTextfield(DisplayNames.kc, editable: isEditable, text: $pdModel.kc)
                    .keyboardType(.numbersAndPunctuation)
                FloatingTextfield(DisplayNames.kp, editable: isEditable, text: $pdModel.kp)
                    .keyboardType(.numbersAndPunctuation)
                FloatingTextfield(DisplayNames.kd, editable: isEditable, text: $pdModel.kd)
                    .keyboardType(.numbersAndPunctuation)
            } else {
                FloatingTextfield(DisplayNames.from, editable: isEditable, text: $pdModel.from)
                    .keyboardType(.numbersAndPunctuation)
                FloatingTextfield(DisplayNames.to, editable: isEditable, text: $pdModel.to)
                    .keyboardType(.numbersAndPunctuation)
                FloatingTextfield(DisplayNames.step, editable: isEditable, text: $pdModel.step)
                    .keyboardType(.numbersAndPunctuation)
                FloatingTextfield(DisplayNames.drying_time, editable: isEditable, text: $pdModel.drying_time)
                    .keyboardType(.numbersAndPunctuation)
            }
        } header: {
            HStack {
                Text(DisplayNames.ht)
                Spacer()
                Button {
                    pdFormDataModel.selectedTitle = DisplayNames.ht
                    pdFormDataModel.showDetail = true
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
    
    var pcHamberView: some View {
        Section {
            Menu {
                ForEach (PrimaryDryingPresetKeys.pchamberKeys, id: \.self) { key in
                    Button(key, action: {
                        pdFormDataModel.pchamberPresetTitle = key
                        pdFormDataModel.tshelfPresetTitle = key
                        updatePresets(type: DisplayNames.pchamber, preset: key)
                    })
                }
            } label: {
                Text(pdFormDataModel.pchamberPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.ramp_rate, editable: isEditable, text: $pdModel.ramp_rate)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.setpt, editable: isEditable, text: $pdModel.setpt)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.dt_setpt, editable: isEditable, text: $pdModel.dt_setpt)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.pchamber)
                Spacer()
                Button {
                    pdFormDataModel.selectedTitle = DisplayNames.pchamber
                    pdFormDataModel.showDetail = true
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
                ForEach (PrimaryDryingPresetKeys.tshelfKeys, id: \.self) { key in
                    Button(key, action: {
                        pdFormDataModel.pchamberPresetTitle = key
                        pdFormDataModel.tshelfPresetTitle = key
                        updatePresets(type: DisplayNames.tshelf, preset: key)
                    })
                }
            } label: {
                Text(pdFormDataModel.tshelfPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.ts_init_val, editable: isEditable, text: $pdModel.ts_init_val)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.ts_ramp_rate, editable: isEditable, text:$pdModel.ts_ramp_rate)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.ts_setpt, editable: isEditable, text:$pdModel.ts_setpt)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.ts_dt_setpt, editable: isEditable, text: $pdModel.ts_dt_setpt)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.tshelf)
                Spacer()
                Button {
                    pdFormDataModel.selectedTitle = DisplayNames.tshelf
                    pdFormDataModel.showDetail = true
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
                ForEach (PrimaryDryingPresetKeys.otherKeys, id: \.self) { key in
                    Button(key, action: {
                        pdFormDataModel.otherPresetTitle = key
                        updatePresets(type: DisplayNames.other_inputs, preset: key)
                    })
                }
            } label: {
                Text(pdFormDataModel.otherPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.time_step, editable: isEditable, text: $pdModel.time_step)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.other_inputs)
                Spacer()
            }
        }
    }
}


extension PrimaryDryInputForm {
    
    func updatePresets(type: String, preset: String){
        
        if (type == DisplayNames.vial) {
            if let vialPreset = PrimaryDryingPresets.vialPresets[preset] {
                pdModel.av = vialPreset.av
                pdModel.ap = vialPreset.ap
                pdModel.vfill = vialPreset.vfill
            }
        }
        else if (type == DisplayNames.product) {
            if let productPreset = PrimaryDryingPresets.productPresets[preset] {
                pdModel.cSolid = productPreset.csolid
                pdModel.cr_temp = productPreset.cr_temp
                pdModel.r0 = productPreset.r0
                pdModel.a1 = productPreset.a1
                pdModel.a2 = productPreset.a2
            }
        }
        else if (type == DisplayNames.ht) {
            if let htPreset = PrimaryDryingPresets.heatTransferPresets[preset] {
                pdModel.kc = htPreset.kc
                pdModel.kp = htPreset.kp
                pdModel.kd = htPreset.kd
            }
        }
        else if (type == DisplayNames.pchamber || type == DisplayNames.tshelf) {
            if let chamberPreset = PrimaryDryingPresets.chamberPresets[preset] {
                pdModel.ramp_rate = chamberPreset.ramp_rate
                pdModel.setpt = chamberPreset.setpt
                pdModel.dt_setpt = chamberPreset.dt_setpt
            }
            if let tshelfPreset = PrimaryDryingPresets.shelfTemperaturePresets[preset] {
                pdModel.ts_init_val = tshelfPreset.init_val
                pdModel.ts_ramp_rate = tshelfPreset.ramp_rate
                pdModel.ts_setpt = tshelfPreset.setpt
                pdModel.ts_dt_setpt = tshelfPreset.dt_setpt
            }
        }
        else if (type == DisplayNames.other_inputs) {
            if let otherPreset = PrimaryDryingPresets.otherPresets[preset] {
                pdModel.time_step = otherPreset.time_step
            }
        }
    }
}


struct PrimaryDryCalculator: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(fetchRequest: PrimaryDryHistory.fetchHistory()) private var histories
    @FetchRequest(fetchRequest: PrimaryDry.fetchAllSaves()) private var saves
    
    @State private var presentAlert = false
    @State private var presentErrorAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var isValidate: Bool = false
   
    
    @State var showHistory: Bool = false
    @State var showGraph: Bool = false

    @State var changeInt: String = ""
    
    @ObservedObject var vm: PrimaryDryViewModel
    
    @StateObject var pdModel = PDModel()
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
            CalculatorOutputView(calculaterUserInputModel: pdModel)
        }
        .fullScreenCover(isPresented: $showHistory, content: {
            PDHistoryRootView()
        })
        .sheet(isPresented: $formDataModel.showDetail, content: {
            InfoPage(title: $formDataModel.selectedTitle)
        })
        .onAppear {
            hideTabBar = true
        }
        .navigationTitle("Primary Drying")
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
            TextField("Enter name to save input", text: $pdModel.name)
            Button("Save",role: .destructive, action: {
                transferToVM()
                vm.primaryDry.date = Date.now
                vm.primaryDry.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
                vm.primaryDry.id = UUID()
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

extension PrimaryDryCalculator {
    
    func clearPresets(){
        formDataModel.vialPresetTitle = DisplayNames.vialPresetTitle
        formDataModel.productPresetTitle = DisplayNames.productPresetTitle
        formDataModel.htPresetTitle = DisplayNames.htPresetTitle
        formDataModel.pchamberPresetTitle = DisplayNames.pchamberPresetTitle
        formDataModel.tshelfPresetTitle = DisplayNames.tshelfPresetTitle
        formDataModel.otherPresetTitle = DisplayNames.otherPresetTitle
    }
}

extension PrimaryDryCalculator {
    
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
    
    private func clearCurrent() {
        pdModel.av = ""
        pdModel.ap = ""
        pdModel.vfill = ""
        pdModel.cSolid = ""
        pdModel.cr_temp = ""
        pdModel.r0 = ""
        pdModel.a1 = ""
        pdModel.a2 = ""
        pdModel.kc = ""
        pdModel.kp = ""
        pdModel.kd = ""
        pdModel.ramp_rate = ""
        pdModel.setpt = ""
        pdModel.dt_setpt = ""
        pdModel.ts_init_val = ""
        pdModel.ts_ramp_rate = ""
        pdModel.ts_setpt = ""
        pdModel.ts_dt_setpt = ""
        pdModel.time_step = ""
        pdModel.from = ""
        pdModel.to = ""
        pdModel.step = ""
        pdModel.drying_time = ""
    }
    
    private func saveCurrentRunToHistory() {
        vm.objectWillChange.send()
        vm.primaryDryHistory.date = Date.now
        vm.primaryDryHistory.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        vm.primaryDryHistory.id = UUID()
        vm.primaryDryHistory.av = pdModel.av
        vm.primaryDryHistory.ap = pdModel.ap
        vm.primaryDryHistory.vfill = pdModel.vfill
        vm.primaryDryHistory.cSolid = pdModel.cSolid
        vm.primaryDryHistory.cr_temp = pdModel.cr_temp
        vm.primaryDryHistory.r0 = pdModel.r0
        vm.primaryDryHistory.a1 = pdModel.a1
        vm.primaryDryHistory.a2 = pdModel.a2
        vm.primaryDryHistory.kc = pdModel.kc
        vm.primaryDryHistory.kp = pdModel.kp
        vm.primaryDryHistory.kd = pdModel.kd
        vm.primaryDryHistory.ramp_rate = pdModel.ramp_rate
        vm.primaryDryHistory.setpt = pdModel.setpt
        vm.primaryDryHistory.dt_setpt = pdModel.dt_setpt
        vm.primaryDryHistory.min = pdModel.min
        vm.primaryDryHistory.max = pdModel.max
        vm.primaryDryHistory.ts_init_val = pdModel.ts_init_val
        vm.primaryDryHistory.ts_ramp_rate = pdModel.ts_ramp_rate
        vm.primaryDryHistory.ts_setpt = pdModel.ts_setpt
        vm.primaryDryHistory.ts_dt_setpt = pdModel.ts_dt_setpt
        vm.primaryDryHistory.min = pdModel.min
        vm.primaryDryHistory.max = pdModel.max
        vm.primaryDryHistory.time_step = pdModel.time_step
        vm.primaryDryHistory.kv_known = pdModel.kv_known
        vm.primaryDryHistory.from = pdModel.from
        vm.primaryDryHistory.to = pdModel.to
        vm.primaryDryHistory.step = pdModel.step
        vm.primaryDryHistory.drying_time = pdModel.drying_time
        vm.objectWillChange.send()
        do {
            try vm.saveHistory()
            print("saved run")
        } catch {
            print("Error saving run: \(error)")
        }
    }
    
    
}

func inputValidationsPD(for pdModel: PDModel) -> Bool {
    // Add your conditions here
    let av: Float = Float(pdModel.av) ?? -1.0
    let ap: Float = Float(pdModel.ap) ?? -1.0
    let vfill: Float = Float(pdModel.vfill) ?? -1.0
    let cSolid: Float = Float(pdModel.cSolid) ?? -1.0
    let cr_temp: Float = Float(pdModel.cr_temp) ?? 200.0
    let r0: Float = Float(pdModel.r0) ?? -1.0
    let a1: Float = Float(pdModel.a1) ?? -1.0
    let a2: Float = Float(pdModel.a2) ?? -1.0
    let kc: Float = Float(pdModel.kc) ?? -1.0
    let kp: Float = Float(pdModel.kp) ?? -1.0
    let kd: Float = Float(pdModel.kd) ?? -1.0
    let ramp_rate: Float = Float(pdModel.ramp_rate) ?? -1.0
    let ts_init_val : Float = Float(pdModel.ts_init_val) ?? 101.0
    let ts_ramp_rate : Float = Float(pdModel.ts_ramp_rate) ?? -1.0
    let time_step : Float = Float(pdModel.time_step) ?? -1.0
    
    if (pdModel.setpt.contains(",")) {
        let setpt_list = pdModel.setpt.split(separator: ",")
        for val in setpt_list {
            if let setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                if (setpt_val < 0.0 || setpt_val > 2000.0){
                    return false
                }
            } else {
                return false
            }
        }
    } else {
        if let setpt = Double(pdModel.setpt) {
            if (setpt < 0.0 || setpt > 2000.0){
                return false
            }
        }
        else{
            return false
        }
    }
    

    if (pdModel.dt_setpt.contains(",")) {
        let dt_setpt_list = pdModel.dt_setpt.split(separator: ",")
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
        if let dt_setpt = Double(pdModel.dt_setpt) {
            if (dt_setpt < 0.0){
                return false
            }
        }
        else{
            return false
        }
    }
    
    
    if (pdModel.ts_setpt.contains(",")) {
        let ts_setpt_list = pdModel.ts_setpt.split(separator: ",")
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
        if let ts_setpt = Double(pdModel.ts_setpt) {
            if (ts_setpt < -60.0 || ts_setpt > 60.0){
                return false
            }
        }
        else{
            return false
        }
    }
    
    if (pdModel.ts_dt_setpt.contains(",")) {
        let ts_dt_setpt_list = pdModel.ts_dt_setpt.split(separator: ",")
        for val in ts_dt_setpt_list {
            if let dt_setpt_val = Double(val.replacingOccurrences(of: " ", with: "")) {
                if (dt_setpt_val < 0.0){
                    return false
                }
            } else {
                return false
            }
        }
    } else {
        if let ts_dt_setpt = Double(pdModel.ts_dt_setpt) {
            if (ts_dt_setpt < 0.0){
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
        cr_temp <= 199.0 &&
        r0 >= 0.0 &&
        a1 >= 0.0 &&
        a2 >= 0.0 &&
        kc > 0.0 &&
        kp > 0.0 &&
        kd > 0.0 &&
        time_step > 0.0 &&
        ramp_rate >= 0.0 &&
        ts_init_val >= -100 && ts_init_val <= 100 &&
        ts_ramp_rate >= 0 {
        return true
    } else {
        return false
    }
}

