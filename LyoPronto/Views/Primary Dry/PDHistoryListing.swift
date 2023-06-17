//
//  HistoryListingView.swift
//  LyoPronto
//

import SwiftUI

struct PDHistoryListingView: View {
    
    @FetchRequest(fetchRequest: PrimaryDryHistory.fetchHistory()) private var histories
    
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
                        PrimaryDryHistoryView(vm: .init(provider: provider, primaryDryHistory: his), pdModel: convertPDModel(his), historyDate: historyDate)
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
            histories.nsPredicate = PrimaryDryHistory.filterHistory(newValue)
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
            PrimaryDryHistory.deleteExcessHistories(using: context)
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
    
    private func deleteSelectedData(_ history: PrimaryDryHistory) throws {
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
    
    private func convertPDModel(_ primaryDry: PrimaryDryHistory) -> PDModel {
        let tempPDModel = PDModel()
        DispatchQueue.main.async {
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
            tempPDModel.min = primaryDry.min ?? ""
            tempPDModel.max = primaryDry.max ?? ""
            tempPDModel.ts_init_val = primaryDry.ts_init_val ?? ""
            tempPDModel.ts_ramp_rate = primaryDry.ts_ramp_rate ?? ""
            tempPDModel.ts_setpt = primaryDry.ts_setpt ?? ""
            tempPDModel.ts_dt_setpt = primaryDry.ts_dt_setpt ?? ""
            tempPDModel.ts_max = primaryDry.ts_max ?? ""
            tempPDModel.ts_min = primaryDry.ts_min ?? ""
            tempPDModel.time_step = primaryDry.time_step ?? ""
            tempPDModel.kv_known = primaryDry.kv_known
            tempPDModel.from = primaryDry.from ?? ""
            tempPDModel.to = primaryDry.to ?? ""
            tempPDModel.step = primaryDry.step ?? ""
            tempPDModel.drying_time = primaryDry.drying_time ?? ""
        }
        return tempPDModel
    }

}
