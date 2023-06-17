//
//  PrimaryDryViewModel1.swift
//  LyoPronto
//


import Foundation
import CoreData

final class FreezingViewModel: ObservableObject {
    
    @Published var freezing: Freezing
    @Published var freezingHistory: FreezingHistory
    
    private let provider: CoreDataProvider
    
    private var freezingContext: NSManagedObjectContext
    private var freezingHistoryContext: NSManagedObjectContext
    
    init(provider: CoreDataProvider, freezing: Freezing? = nil, freezingHistory: FreezingHistory? = nil) {
        self.provider = provider
        self.freezingContext = provider.newContext
        self.freezingHistoryContext = provider.newContext
        
        if let freezing,
           let existingFreezingCopy = provider.saveExistsFreezing(freezing, in: freezingContext) {
            self.freezing = existingFreezingCopy
        } else {
            self.freezing = Freezing(context: self.freezingContext)
        }
        
        if let freezingHistory,
           let existingFreezingHistoryCopy = provider.historyExistsFreezing(freezingHistory, in: freezingHistoryContext) {
            self.freezingHistory = existingFreezingHistoryCopy
        } else {
            self.freezingHistory = FreezingHistory(context: self.freezingHistoryContext)
        }
        
    }
    
    func newContext() {
        self.freezingContext = provider.newContext
        self.freezingHistoryContext = provider.newContext
        self.freezing = Freezing(context: self.freezingContext)
        self.freezingHistory = FreezingHistory(context: self.freezingHistoryContext)
    }
    
    func saveRun() throws {
        try provider.persists(in: freezingContext)
    }
    
    func saveHistory() throws {
        try provider.persists(in: freezingHistoryContext)
    }
    
    func validate() -> Bool {
        let av: Float = Float(freezing.av!) ?? 0.0
        let ap: Float = Float(freezing.ap!) ?? 0.0
        let vfill: Float = Float(freezing.vfill!) ?? 0.0
        let cSolid: Float = Float(freezing.cSolid!) ?? 0.0
        let _: Float = Float(freezing.tpr0!) ?? 0.0
        let _: Float = Float(freezing.tf!) ?? 0.0
        let _: Float = Float(freezing.tn!) ?? 0.0
        let ts_init_val : Float = Float(freezing.ts_init_val!) ?? 0.0
        let _ : Float = Float(freezing.ts_ramp_rate!) ?? 0.0
        let ts_setpt : Float = Float(freezing.ts_setpt!) ?? 0.0
        let ts_dt_setpt : Float = Float(freezing.ts_dt_setpt!) ?? 0.0
        let _ : Float = Float(freezing.time_step!) ?? 0.0
        let _ : Float = Float(freezing.h_freezing!) ?? 0.0
        
        if av >= 0 &&
            ap >= 0 &&
            vfill >= 0.0 &&
            cSolid >= 0.0 && cSolid <= 90 &&
            ts_init_val >= -60 && ts_init_val <= 0 &&
            ts_setpt >= -60 && ts_setpt <= 60 &&
            ts_dt_setpt >= 0 {
            return true
        } else {
            return false
        }
    }
    
}
