//
//  DesignSpaceCalculator.swift
//  LyoPronto
//

import SwiftUI



class DSFormDataModel: ObservableObject {
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


struct DesignSpaceInputForm: View {
    
    @ObservedObject var designSpaceModel: DesignSpaceModel
    @ObservedObject var dsFormDataModel: DSFormDataModel

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
            equipCapbilityView
            additionalInputsView
        }
    }
}

extension DesignSpaceInputForm {
    
    var vialView: some View {
        Section {
            Menu {
                ForEach (DesignSpacePresetKeys.vialKeys, id: \.self) { key in
                    Button(key, action: {
                        dsFormDataModel.vialPresetTitle = key
                        updatePresets(type: DisplayNames.vial, preset: key)
                    })
                }
            } label: {
                Text(dsFormDataModel.vialPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.av, editable: isEditable, text: $designSpaceModel.av)
                .keyboardType(.numbersAndPunctuation)
                .focused($isTextFieldFocused)
            FloatingTextfield(DisplayNames.ap, editable: isEditable, text: $designSpaceModel.ap)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.vfill, editable: isEditable, text: $designSpaceModel.vfill)
                .keyboardType(.numbersAndPunctuation)
            
        } header: {
            HStack {
                Text(DisplayNames.vial)
                Spacer()
                Button {
                    dsFormDataModel.selectedTitle = DisplayNames.vial
                    dsFormDataModel.showDetail = true
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
                ForEach (DesignSpacePresetKeys.productKeys, id: \.self) { key in
                    Button(key, action: {
                        dsFormDataModel.productPresetTitle = key
                        updatePresets(type: DisplayNames.product, preset: key)
                    })
                }
            } label: {
                Text(dsFormDataModel.productPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.cSolid, editable: isEditable, text: $designSpaceModel.cSolid)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.cr_temp, editable: isEditable, text: $designSpaceModel.cr_temp)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.r0, editable: isEditable, text: $designSpaceModel.r0)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.a1, editable: isEditable, text: $designSpaceModel.a1)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.a2, editable: isEditable, text: $designSpaceModel.a2)
                .keyboardType(.numbersAndPunctuation)
            
        } header: {
            HStack {
                Text(DisplayNames.product)
                Spacer()
                Button {
                    dsFormDataModel.selectedTitle = DisplayNames.product
                    dsFormDataModel.showDetail = true
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
            Menu {
                ForEach (DesignSpacePresetKeys.heatTransferKeys, id: \.self) { key in
                    Button(key, action: {
                        dsFormDataModel.htPresetTitle = key
                        updatePresets(type: DisplayNames.ht, preset: key)
                    })
                }
            } label: {
                Text(dsFormDataModel.htPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.kc, editable: isEditable, text: $designSpaceModel.kc)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.kp, editable: isEditable, text: $designSpaceModel.kp)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.kd, editable: isEditable, text: $designSpaceModel.kd)
                .keyboardType(.numbersAndPunctuation)
        }
         header: {
            HStack {
                Text(DisplayNames.ht)
                Spacer()
                Button {
                    dsFormDataModel.selectedTitle = DisplayNames.ht
                    dsFormDataModel.showDetail = true
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
                ForEach (DesignSpacePresetKeys.pchamberKeys, id: \.self) { key in
                    Button(key, action: {
                        dsFormDataModel.pchamberPresetTitle = key
                        dsFormDataModel.tshelfPresetTitle = key
                        updatePresets(type: DisplayNames.pchamber, preset: key)
                    })
                }
            } label: {
                Text(dsFormDataModel.pchamberPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.ramp_rate, editable: isEditable, text: $designSpaceModel.ramp_rate)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.setpt, editable: isEditable, text: $designSpaceModel.setpt)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.pchamber)
                Spacer()
                Button {
                    dsFormDataModel.selectedTitle = DisplayNames.pchamber
                    dsFormDataModel.showDetail = true
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
                ForEach (DesignSpacePresetKeys.tshelfKeys, id: \.self) { key in
                    Button(key, action: {
                        dsFormDataModel.pchamberPresetTitle = key
                        dsFormDataModel.tshelfPresetTitle = key
                        updatePresets(type: DisplayNames.tshelf, preset: key)
                    })
                }
            } label: {
                Text(dsFormDataModel.tshelfPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.ts_init_val, editable: isEditable, text: $designSpaceModel.ts_init_val)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.ts_ramp_rate, editable: isEditable, text:$designSpaceModel.ts_ramp_rate)
                .keyboardType(.numbersAndPunctuation)
            
            FloatingTextfield(DisplayNames.ts_setpt, editable: isEditable, text:$designSpaceModel.ts_setpt)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.tshelf)
                Spacer()
                Button {
                    dsFormDataModel.selectedTitle = DisplayNames.tshelf
                    dsFormDataModel.showDetail = true
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
    
    var equipCapbilityView:some View {
        Section {
            Menu {
                ForEach (DesignSpacePresetKeys.equipCapKeys, id: \.self) { key in
                    Button(key, action: {
                        dsFormDataModel.eqpCapPresetTitle = key
                        updatePresets(type: DisplayNames.equipcapability, preset: key)
                    })
                }
            } label: {
                Text(dsFormDataModel.eqpCapPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.equip_a, editable: isEditable, text: $designSpaceModel.equip_a)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.equip_b, editable: isEditable, text: $designSpaceModel.equip_b)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.equipcapability)
                Spacer()
                Button {
                    dsFormDataModel.selectedTitle = DisplayNames.equipcapability
                    dsFormDataModel.showDetail = true
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
                ForEach (DesignSpacePresetKeys.otherKeys, id: \.self) { key in
                    Button(key, action: {
                        dsFormDataModel.otherPresetTitle = key
                        updatePresets(type: DisplayNames.other_inputs, preset: key)
                    })
                }
            } label: {
                Text(dsFormDataModel.otherPresetTitle).frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .font(.headline)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 2, y: 2)
            .contentShape(Rectangle())
            
            FloatingTextfield(DisplayNames.time_step, editable: isEditable, text: $designSpaceModel.time_step)
                .keyboardType(.numbersAndPunctuation)
            FloatingTextfield(DisplayNames.n_vials, editable: isEditable, text: $designSpaceModel.n_vials)
                .keyboardType(.numbersAndPunctuation)
        } header: {
            HStack {
                Text(DisplayNames.other_inputs)
                Spacer()
            }
        }
    }
}


extension DesignSpaceInputForm {
    
    func updatePresets(type: String, preset: String){
        
        if (type == DisplayNames.vial) {
            if let vialPreset = DesignSpacePresets.vialPresets[preset] {
                designSpaceModel.av = vialPreset.av
                designSpaceModel.ap = vialPreset.ap
                designSpaceModel.vfill = vialPreset.vfill
            }
        }
        else if (type == DisplayNames.product) {
            if let productPreset = DesignSpacePresets.productPresets[preset] {
                designSpaceModel.cSolid = productPreset.csolid
                designSpaceModel.cr_temp = productPreset.cr_temp
                designSpaceModel.r0 = productPreset.r0
                designSpaceModel.a1 = productPreset.a1
                designSpaceModel.a2 = productPreset.a2
            }
        }
        else if (type == DisplayNames.ht) {
            if let htPreset = DesignSpacePresets.heatTransferPresets[preset] {
                designSpaceModel.kc = htPreset.kc
                designSpaceModel.kp = htPreset.kp
                designSpaceModel.kd = htPreset.kd
            }
        }
        else if (type == DisplayNames.pchamber || type == DisplayNames.tshelf) {
            if let chamberPreset = DesignSpacePresets.chamberPresets[preset] {
                designSpaceModel.ramp_rate = chamberPreset.ramp_rate
                designSpaceModel.setpt = chamberPreset.setpt
            }
            if let tshelfPreset = DesignSpacePresets.shelfTemperaturePresets[preset] {
                designSpaceModel.ts_init_val = tshelfPreset.init_val
                designSpaceModel.ts_ramp_rate = tshelfPreset.ramp_rate
                designSpaceModel.ts_setpt = tshelfPreset.setpt
            }
        }
        else if (type == DisplayNames.other_inputs) {
            if let otherPreset = DesignSpacePresets.otherPresets[preset] {
                designSpaceModel.time_step = otherPreset.time_step
                designSpaceModel.n_vials = otherPreset.num_vials
            }
        }
        else if (type == DisplayNames.equipcapability) {
            if let eqpCapPreset = DesignSpacePresets.eqpCapPresets[preset] {
                designSpaceModel.equip_a = eqpCapPreset.a
                designSpaceModel.equip_b = eqpCapPreset.b
            }
        }
    }
}










struct DesignSpaceCalculator: View {

    @AppStorage("HideTabBar") var hideTabBar: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @FetchRequest(fetchRequest: DesignSpaceHistory.fetchHistory()) private var histories
    @FetchRequest(fetchRequest: DesignSpace.fetchAllSaves()) private var saves
    
    @State private var presentAlert = false
    @State private var presentErrorAlert = false
    @State private var saveInputTextFieldStr: String = ""
    @State private var showWebView = false
    @State private var isValidate: Bool = false
    
    @State var showHistory: Bool = false
    @State var showGraph: Bool = false
    
    @ObservedObject var vm: DesignSpaceViewModel
    @StateObject var designSpaceModel = DesignSpaceModel()
    @StateObject private var formDataModel = DSFormDataModel()
    
    @StateObject var outputVM = DesignSpaceOutputViewModel()
    
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
            DSCalculatorOutputView(calculaterUserInputModel: designSpaceModel)
        }
        .fullScreenCover(isPresented: $showHistory, content: {
            DesignSpaceHistoryRootView()
        })
        .sheet(isPresented: $formDataModel.showDetail, content: {
            InfoPage(title: $formDataModel.selectedTitle)
        })
        .onAppear {
            hideTabBar = true
        }
        .navigationTitle("Design Space")
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
//        .gesture(
//          DragGesture(coordinateSpace: .local)
//            .onEnded { value in
//              if value.translation.width > .zero
//                  && value.translation.height > -30
//                  && value.translation.height < 30 {
//                dismiss()
//              }
//            }
//        )
        .alert("Save Input", isPresented: $presentAlert, actions: {
            TextField("Enter name to save input", text: $designSpaceModel.name)
            Button("Save",role: .destructive, action: {
                tranferToVM()
                vm.designSpace.date = Date.now
                vm.designSpace.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
                vm.designSpace.id = UUID()
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

extension DesignSpaceCalculator {
    func clearPresets(){
        formDataModel.vialPresetTitle = DisplayNames.vialPresetTitle
        formDataModel.productPresetTitle = DisplayNames.productPresetTitle
        formDataModel.htPresetTitle = DisplayNames.htPresetTitle
        formDataModel.pchamberPresetTitle = DisplayNames.pchamberPresetTitle
        formDataModel.tshelfPresetTitle = DisplayNames.tshelfPresetTitle
        formDataModel.eqpCapPresetTitle = DisplayNames.eqpCapPresetTitle
        formDataModel.otherPresetTitle = DisplayNames.otherPresetTitle
    }
}

extension DesignSpaceCalculator {
    
    private func tranferToVM() {
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
        vm.designSpace.time_step = designSpaceModel.time_step
        vm.designSpace.n_vials = designSpaceModel.n_vials
        vm.designSpace.equip_a = designSpaceModel.equip_a
        vm.designSpace.equip_b = designSpaceModel.equip_b
        vm.objectWillChange.send()
    }
    
    private func clearCurrent() {
        designSpaceModel.av = ""
        designSpaceModel.ap = ""
        designSpaceModel.vfill = ""
        designSpaceModel.cSolid = ""
        designSpaceModel.cr_temp = ""
        designSpaceModel.r0 = ""
        designSpaceModel.a1 = ""
        designSpaceModel.a2 = ""
        designSpaceModel.kc = ""
        designSpaceModel.kp = ""
        designSpaceModel.kd = ""
        designSpaceModel.ramp_rate = ""
        designSpaceModel.setpt = ""
        designSpaceModel.ts_init_val = ""
        designSpaceModel.ts_ramp_rate = ""
        designSpaceModel.ts_setpt = ""
        designSpaceModel.time_step = ""
        designSpaceModel.n_vials = ""
        designSpaceModel.equip_a = ""
        designSpaceModel.equip_b = ""
    }
    
    private func saveCurrentRunToHistory() {
        vm.objectWillChange.send()
        vm.designSpaceHistory.date = Date.now
        vm.designSpaceHistory.dateString = Date.now.formatted(date: .abbreviated, time: .standard)
        vm.designSpaceHistory.id = UUID()
        vm.designSpaceHistory.av = designSpaceModel.av
        vm.designSpaceHistory.ap = designSpaceModel.ap
        vm.designSpaceHistory.vfill = designSpaceModel.vfill
        vm.designSpaceHistory.cSolid = designSpaceModel.cSolid
        vm.designSpaceHistory.cr_temp = designSpaceModel.cr_temp
        vm.designSpaceHistory.r0 = designSpaceModel.r0
        vm.designSpaceHistory.a1 = designSpaceModel.a1
        vm.designSpaceHistory.a2 = designSpaceModel.a2
        vm.designSpaceHistory.kc = designSpaceModel.kc
        vm.designSpaceHistory.kp = designSpaceModel.kp
        vm.designSpaceHistory.kd = designSpaceModel.kd
        vm.designSpaceHistory.ramp_rate = designSpaceModel.ramp_rate
        vm.designSpaceHistory.setpt = designSpaceModel.setpt
        vm.designSpaceHistory.ts_init_val = designSpaceModel.ts_init_val
        vm.designSpaceHistory.ts_ramp_rate = designSpaceModel.ts_ramp_rate
        vm.designSpaceHistory.ts_setpt = designSpaceModel.ts_setpt
        vm.designSpaceHistory.time_step = designSpaceModel.time_step
        vm.designSpaceHistory.n_vials = designSpaceModel.n_vials
        vm.designSpaceHistory.equip_a = designSpaceModel.equip_a
        vm.designSpaceHistory.equip_b = designSpaceModel.equip_b
        vm.objectWillChange.send()
        do {
            try vm.saveHistory()
            print("saved run")
        } catch {
            print("Error saving run: \(error)")
        }
    }
    
    
}


func inputValidationsDS(for designSpaceModel: DesignSpaceModel) -> Bool {
    let av: Float = Float(designSpaceModel.av) ?? -1.0
    let ap: Float = Float(designSpaceModel.ap) ?? -1.0
    let vfill: Float = Float(designSpaceModel.vfill) ?? -1.0
    let cSolid: Float = Float(designSpaceModel.cSolid) ?? -1.0
    let cr_temp: Float = Float(designSpaceModel.cr_temp) ?? 200.0
    let r0: Float = Float(designSpaceModel.r0) ?? -1.0
    let a1: Float = Float(designSpaceModel.a1) ?? -1.0
    let a2: Float = Float(designSpaceModel.a2) ?? -1.0
    let kc: Float = Float(designSpaceModel.kc) ?? -1.0
    let kp: Float = Float(designSpaceModel.kp) ?? -1.0
    let kd: Float = Float(designSpaceModel.kd) ?? -1.0
    let ramp_rate: Float = Float(designSpaceModel.ramp_rate) ?? -1.0
    let ts_init_val : Float = Float(designSpaceModel.ts_init_val) ?? 101.0
    let ts_ramp_rate : Float = Float(designSpaceModel.ts_ramp_rate) ?? -1.0
    let time_step : Float = Float(designSpaceModel.time_step) ?? -1.0
    let n_vials : Float = Float(designSpaceModel.n_vials) ?? -1.0
    let equip_a : Float = Float(designSpaceModel.equip_a) ?? -1000.0
    let equip_b : Float = Float(designSpaceModel.equip_b) ?? -1000.0
    
    if (designSpaceModel.setpt.contains(",")) {
        let setpt_list = designSpaceModel.setpt.split(separator: ",")
        
        // A maximum of 5 setpoint values allowed
        if (setpt_list.count > 5) {
            return false
        }
        
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
        if let setpt = Double(designSpaceModel.setpt) {
            if (setpt < 0.0 || setpt > 2000.0){
                return false
            }
        }
        else{
            return false
        }
    }
    
    if (designSpaceModel.ts_setpt.contains(",")) {
        let ts_setpt_list = designSpaceModel.ts_setpt.split(separator: ",")
        
        // A maximum of 5 setpoint values allowed
        if (ts_setpt_list.count > 5) {
            return false
        }
        
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
        if let ts_setpt = Double(designSpaceModel.ts_setpt) {
            if (ts_setpt < -60.0 || ts_setpt > 60.0){
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
        n_vials >= 1.0 &&
        equip_a >= -999.0 &&
        equip_b >= -999.0 &&
        ts_init_val >= -100 && ts_init_val <= 100 &&
        ts_ramp_rate >= 0 {
        return true
    } else {
        return false
    }
}
