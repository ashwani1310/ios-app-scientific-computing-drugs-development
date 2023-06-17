//
//  DesignSpaceSaveListing.swift
//  LyoPronto
//

import SwiftUI

struct DesignSpaceSaveListingView: View {
    
    @FetchRequest(fetchRequest: DesignSpace.fetchAllSaves()) private var saves
    
    var provider = CoreDataProvider.shared
    
    @State private var query: String = ""
    
    var body: some View {
        List {
            ForEach(saves) { save in
                NavigationLink {
                    DesignSpaceSaveView(vm: .init(provider: provider, designSpace: save), designSpaceModel: convertDSModel(save))
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
            saves.nsPredicate = DesignSpace.filterSaves(newValue)
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
    
    private func deleteSelectedData(_ save: DesignSpace) throws {
        let context = provider.newContext
        let existingSave = try context.existingObject(with: save.objectID)
        context.delete(existingSave)
        Task(priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
    
    private func convertDSModel(_ designSpaceModel: DesignSpace) -> DesignSpaceModel {
        let tempDSModel = DesignSpaceModel()
        DispatchQueue.main.async {
            tempDSModel.name = designSpaceModel.name ?? ""
            tempDSModel.av = designSpaceModel.av ?? ""
            tempDSModel.ap = designSpaceModel.ap ?? ""
            tempDSModel.vfill = designSpaceModel.vfill ?? ""
            tempDSModel.cSolid = designSpaceModel.cSolid ?? ""
            tempDSModel.cr_temp = designSpaceModel.cr_temp ?? ""
            tempDSModel.r0 = designSpaceModel.r0 ?? ""
            tempDSModel.a1 = designSpaceModel.a1 ?? ""
            tempDSModel.a2 = designSpaceModel.a2 ?? ""
            tempDSModel.kc = designSpaceModel.kc ?? ""
            tempDSModel.kp = designSpaceModel.kp ?? ""
            tempDSModel.kd = designSpaceModel.kd ?? ""
            tempDSModel.ramp_rate = designSpaceModel.ramp_rate ?? ""
            tempDSModel.setpt = designSpaceModel.setpt ?? ""
            tempDSModel.ts_init_val = designSpaceModel.ts_init_val ?? ""
            tempDSModel.ts_ramp_rate = designSpaceModel.ts_ramp_rate ?? ""
            tempDSModel.ts_setpt = designSpaceModel.ts_setpt ?? ""
            tempDSModel.equip_a = designSpaceModel.equip_a ?? ""
            tempDSModel.equip_b = designSpaceModel.equip_b ?? ""
            tempDSModel.time_step = designSpaceModel.time_step ?? ""
            tempDSModel.n_vials = designSpaceModel.n_vials ?? ""
        }
        return tempDSModel
    }
    
}
