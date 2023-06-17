//
//  PrimaryDryViewModel1.swift
//  LyoPronto
//

import Foundation
import CoreData

final class PrimaryDryViewModel: ObservableObject {
    
    @Published var primaryDry: PrimaryDry
    @Published var primaryDryHistory: PrimaryDryHistory
    
    private let provider: CoreDataProvider
    
    private var primaryDryContext: NSManagedObjectContext
    private var primaryDryHistoryContext: NSManagedObjectContext
    
    init(provider: CoreDataProvider, primaryDry: PrimaryDry? = nil, primaryDryHistory: PrimaryDryHistory? = nil) {
        self.provider = provider
        self.primaryDryContext = provider.newContext
        self.primaryDryHistoryContext = provider.newContext
        
        if let primaryDry,
           let existingPrimaryDryCopy = provider.saveExistsPrimaryDry(primaryDry, in: primaryDryContext) {
            self.primaryDry = existingPrimaryDryCopy
        } else {
            self.primaryDry = PrimaryDry(context: self.primaryDryContext)
        }
        
        if let primaryDryHistory,
           let existingPrimaryDryHistoryCopy = provider.historyExistsPrimaryDry(primaryDryHistory, in: primaryDryHistoryContext) {
            self.primaryDryHistory = existingPrimaryDryHistoryCopy
        } else {
            self.primaryDryHistory = PrimaryDryHistory(context: self.primaryDryHistoryContext)
        }
        
    }
    
    func newContext() {
        self.primaryDryContext = provider.newContext
        self.primaryDryHistoryContext = provider.newContext
        self.primaryDry = PrimaryDry(context: self.primaryDryContext)
        self.primaryDryHistory = PrimaryDryHistory(context: self.primaryDryHistoryContext)
    }
    
    func saveRun() throws {
        try provider.persists(in: primaryDryContext)
    }
    
    func saveHistory() throws {
        try provider.persists(in: primaryDryHistoryContext)
    }
    
    func validate() -> Bool {
        let av: Float = Float(primaryDry.av!) ?? 0.0
        let ap: Float = Float(primaryDry.ap!) ?? 0.0
        let vfill: Float = Float(primaryDry.vfill!) ?? 0.0
        let cSolid: Float = Float(primaryDry.cSolid!) ?? 0.0
        let cr_temp: Float = Float(primaryDry.cr_temp!) ?? 0.0
        let r0: Float = Float(primaryDry.r0!) ?? 0.0
        let a1: Float = Float(primaryDry.a1!) ?? 0.0
        let a2: Float = Float(primaryDry.a2!) ?? 0.0
        let kc: Float = Float(primaryDry.kc!) ?? 0.0
        let kp: Float = Float(primaryDry.kp!) ?? 0.0
        let kd: Float = Float(primaryDry.kd!) ?? 0.0
        let ramp_rate: Float = Float(primaryDry.ramp_rate!) ?? 0.0
        let setpt: Float = Float(primaryDry.setpt!) ?? 0.0
        let dt_setpt: Float = Float(primaryDry.dt_setpt!) ?? 0.0
//        let min: Float = Float(primaryDry.min!) ?? 0.0
//        let max: Float = Float(primaryDry.max!) ?? 0.0
        let ts_init_val : Float = Float(primaryDry.ts_init_val!) ?? 0.0
//        let ts_ramp_rate : Float = Float(primaryDry.ts_ramp_rate!) ?? 0.0
        let ts_setpt : Float = Float(primaryDry.ts_setpt!) ?? 0.0
        let ts_dt_setpt : Float = Float(primaryDry.ts_dt_setpt!) ?? 0.0
//        let ts_max : Float = Float(primaryDry.ts_max!) ?? 0.0
//        let ts_min : Float = Float(primaryDry.ts_min!) ?? 0.0
//        let time_step : Float = Float(primaryDry.time_step!) ?? 0.0
        
        if av >= 0 &&
            ap >= 0 &&
            vfill >= 0.0 &&
            cSolid >= 0.0 && cSolid <= 90 &&
            cr_temp <= 0 &&
            r0 >= 0.0 &&
            a1 >= 0.0 &&
            a2 >= 0.0 &&
            kc >= 0.0 &&
            kp >= 0.0 &&
            kd >= 0.0 &&
            setpt >= 0.0 && setpt <= 2000 &&
            dt_setpt >= 0.0 &&
            ramp_rate >= 0.0 &&
            ts_init_val >= -60 && ts_init_val <= 0 &&
            ts_setpt >= -60 && ts_setpt <= 60 &&
            ts_dt_setpt >= 0 &&
            ramp_rate >= 0 && ramp_rate <= 10 {
            return true
        } else {
            return false
        }
    }
    
}
