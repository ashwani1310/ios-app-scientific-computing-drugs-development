//
//  FreezingSaveListing.swift
//  LyoPronto
//

import SwiftUI

struct FreezingSaveListingView: View {
    
    @FetchRequest(fetchRequest: Freezing.fetchAllSaves()) private var saves
    
    var provider = CoreDataProvider.shared
    
    @State private var query: String = ""
    
    var body: some View {
        List {
            ForEach(saves) { save in
                NavigationLink {
                    FreezingSaveView(vm: .init(provider: provider, freezing: save), freezingModel: convertFModel(save))
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
            saves.nsPredicate = Freezing.filterSaves(newValue)
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
    
    private func deleteSelectedData(_ save: Freezing) throws {
        let context = provider.newContext
        let existingSave = try context.existingObject(with: save.objectID)
        context.delete(existingSave)
        Task(priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
    
    private func convertFModel(_ freezingModel: Freezing) -> FreezingModel {
        let tempFModel = FreezingModel()
        DispatchQueue.main.async {
            tempFModel.name = freezingModel.name ?? ""
            tempFModel.av = freezingModel.av ?? ""
            tempFModel.ap = freezingModel.ap ?? ""
            tempFModel.vfill = freezingModel.vfill ?? ""
            tempFModel.cSolid = freezingModel.cSolid ?? ""
            tempFModel.cr_temp = freezingModel.cr_temp ?? ""
            tempFModel.tpr0 = freezingModel.tpr0 ?? ""
            tempFModel.tf = freezingModel.tf ?? ""
            tempFModel.tn = freezingModel.tn ?? ""
            tempFModel.ts_init_val = freezingModel.ts_init_val ?? ""
            tempFModel.ts_ramp_rate = freezingModel.ts_ramp_rate ?? ""
            tempFModel.ts_setpt = freezingModel.ts_setpt ?? ""
            tempFModel.ts_dt_setpt = freezingModel.ts_dt_setpt ?? ""
            tempFModel.time_step = freezingModel.time_step ?? ""
            tempFModel.h_freezing = freezingModel.h_freezing ?? ""
        }
        return tempFModel
    }
    
}
