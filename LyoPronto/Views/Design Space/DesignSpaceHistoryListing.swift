//
//  DesignSpaceHistoryListing.swift
//  LyoPronto
//

import SwiftUI

struct DesignSpaceHistoryListingView: View {
    
    @FetchRequest(fetchRequest: DesignSpaceHistory.fetchHistory()) private var histories
    
    var provider = CoreDataProvider.shared
    
    @State private var query: String = ""
    @State private var showDetail: Bool = false
    @State private var selectedTitle: String = ""
    
    var body: some View {
        List {
            Section {
                ForEach(histories) { his in
                    let historyDate = his.date?.formatted(date: .long, time: .standard) ?? ""
                    NavigationLink {
                        DesignSpaceHistoryView(vm: .init(provider: provider, designSpaceHistory: his), designSpaceModel: convertDSModel(his), historyDate: historyDate)
                    } label: {
                        Text(his.dateString!)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            do {
                                try deleteSelectedData(his)
                            } catch {
                                print(error.localizedDescription)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            } header: {
                HStack {
                    Spacer()
                    Button {
                        selectedTitle = DisplayNames.history
                        showDetail = true
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
        .padding(.top)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: query, perform: { newValue in
            histories.nsPredicate = DesignSpaceHistory.filterHistory(newValue)
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
        .onAppear {
            let context = provider.newContext
            DesignSpaceHistory.deleteExcessHistories(using: context)
        }
        .sheet(isPresented: $showDetail, content: {
            InfoPage(title: $selectedTitle)
        })
    }
    
    private func deleteAllData() throws {
        let context = provider.newContext
        try histories.forEach { history in
            let existingHistory = try context.existingObject(with: history.objectID)
            context.delete(existingHistory)
        }
        Task(priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
    
    private func deleteSelectedData(_ history: DesignSpaceHistory) throws {
        let context = provider.newContext
        let existingHistory = try context.existingObject(with: history.objectID)
        context.delete(existingHistory)
        Task(priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
    
    private func giveDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:MM:SS"
        let dateString = formatter.string(from: date!)
        return dateString
    }
    
    private func convertDSModel(_ designSpaceModel: DesignSpaceHistory) -> DesignSpaceModel {
        let tempDSModel = DesignSpaceModel()
        DispatchQueue.main.async {
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
