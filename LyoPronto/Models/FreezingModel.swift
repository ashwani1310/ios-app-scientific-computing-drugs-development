//
//  PDModel.swift
//  LyoPronto
//

import Foundation

class FreezingModel: ObservableObject {
    
    @Published var av: String = ""
    @Published var ap: String = ""
    @Published var vfill: String = ""
    
    @Published var cSolid: String = ""
    @Published var cr_temp: String = ""
    @Published var tpr0: String = ""
    @Published var tf: String = ""
    @Published var tn: String = ""
    
    @Published var ts_init_val: String = ""
    @Published var ts_ramp_rate: String = ""
    @Published var ts_setpt: String = ""
    @Published var ts_dt_setpt: String = ""
   
    @Published var time_step: String = ""
    @Published var h_freezing: String = ""
    @Published var name: String = ""
}

