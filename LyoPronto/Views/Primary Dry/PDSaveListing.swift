//
//  SaveListingView.swift
//  LyoPronto
//
	

import SwiftUI

struct PDSaveView: View {
    
    @FetchRequest(fetchRequest: PrimaryDry.fetchAllSaves()) private var saves
    
    var provider = CoreDataProvider.shared
    
    @State private var query: String = ""
	
	var body: some View {
        List {
            ForEach(saves) { save in
                NavigationLink {
                    PrimaryDrySaveView(vm: .init(provider: provider, primaryDry: save), pdModel: convertPDModel(save))
                } label: {
                    Text(save.name!)
                }
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        do {
                            try deleteSelectedData(save)
                        } catch {
                            print(error.localizedDescription)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .padding(.top)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: query, perform: { newValue in
            saves.nsPredicate = PrimaryDry.filterSaves(newValue)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    do {
                        try deleteAllData()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
        }
	}
    
    private func deleteAllData() throws {
        let context = provider.newContext
        try saves.forEach { save in
            let existingSave = try context.existingObject(with: save.objectID)
            context.delete(existingSave)
        }
        Task(priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
    
    private func deleteSelectedData(_ save: PrimaryDry) throws {
        let context = provider.newContext
        let existingSave = try context.existingObject(with: save.objectID)
        context.delete(existingSave)
        Task(priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
    
    private func convertPDModel(_ primaryDry: PrimaryDry) -> PDModel {
        let tempPDModel = PDModel()
        DispatchQueue.main.async {
            tempPDModel.name = primaryDry.name!
            tempPDModel.av = primaryDry.av!
            tempPDModel.ap = primaryDry.ap!
            tempPDModel.vfill = primaryDry.vfill!
            tempPDModel.cSolid = primaryDry.cSolid!
            tempPDModel.cr_temp = primaryDry.cr_temp!
            tempPDModel.r0 = primaryDry.r0!
            tempPDModel.a1 = primaryDry.a1!
            tempPDModel.a2 = primaryDry.a2!
            tempPDModel.kc = primaryDry.kc!
            tempPDModel.kp = primaryDry.kp!
            tempPDModel.kd = primaryDry.kd!
            tempPDModel.ramp_rate = primaryDry.ramp_rate!
            tempPDModel.setpt = primaryDry.setpt!
            tempPDModel.dt_setpt = primaryDry.dt_setpt!
            tempPDModel.min = primaryDry.min!
            tempPDModel.max = primaryDry.max!
            tempPDModel.ts_init_val = primaryDry.ts_init_val!
            tempPDModel.ts_ramp_rate = primaryDry.ts_ramp_rate!
            tempPDModel.ts_setpt = primaryDry.ts_setpt!
            tempPDModel.ts_dt_setpt = primaryDry.ts_dt_setpt!
            tempPDModel.ts_max = primaryDry.ts_max!
            tempPDModel.ts_min = primaryDry.ts_min!
            tempPDModel.time_step = primaryDry.time_step!
            tempPDModel.kv_known = primaryDry.kv_known
            tempPDModel.from = primaryDry.from!
            tempPDModel.to = primaryDry.to!
            tempPDModel.step = primaryDry.step!
            tempPDModel.drying_time = primaryDry.drying_time!
        }
        return tempPDModel
    }
    
}



struct PDSaveListingView: View {
    
    var body: some View {
        PDSaveView()
    }
    
}






