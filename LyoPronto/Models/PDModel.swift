//
//  PDModel.swift
//  LyoPronto
//

import Foundation

class PDModel: ObservableObject {
    
    @Published var av: String = ""
    @Published var ap: String = ""
    @Published var vfill: String = ""
    
    @Published var cSolid: String = ""
    @Published var cr_temp: String = ""
    @Published var r0: String = ""
    @Published var a1: String = ""
    @Published var a2: String = ""
    
    @Published var kc: String = ""
    @Published var kp: String = ""
    @Published var kd: String = ""
    @Published var kv_known: Bool = true
    @Published var from: String = ""
    @Published var to: String = ""
    @Published var step: String = ""
    @Published var drying_time: String = ""
    
    @Published var ramp_rate: String = ""
    @Published var setpt: String = ""
    @Published var dt_setpt: String = ""
    @Published var min: String = ""
    @Published var max: String = ""
    
    @Published var ts_init_val: String = ""
    @Published var ts_ramp_rate: String = ""
    @Published var ts_setpt: String = ""
    @Published var ts_dt_setpt: String = ""
    @Published var ts_min: String = ""
    @Published var ts_max: String = ""
    
    @Published var time_step: String = ""
    @Published var name: String = ""
}
