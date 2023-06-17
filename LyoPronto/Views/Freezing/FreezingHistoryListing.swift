//
//  FreezingHistoryListing.swift
//  LyoPronto
//

import SwiftUI

struct FreezingHistoryListingView: View {
    
    @FetchRequest(fetchRequest: FreezingHistory.fetchHistory()) private var histories
    
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
                        FreezingHistoryView(vm: .init(provider: provider, freezingHistory: his), freezingModel: convertFModel(his), historyDate: historyDate)
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
            histories.nsPredicate = FreezingHistory.filterHistory(newValue)
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
            FreezingHistory.deleteExcessHistories(using: context)
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
    
    private func deleteSelectedData(_ history: FreezingHistory) throws {
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
    
    private func convertFModel(_ freezingModel: FreezingHistory) -> FreezingModel {
        let tempFModel = FreezingModel()
        DispatchQueue.main.async {
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

