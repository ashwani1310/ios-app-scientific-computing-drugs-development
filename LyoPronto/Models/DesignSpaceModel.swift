//
//  DesignSpaceModel.swift
//  LyoPronto
//

import Foundation

class DesignSpaceModel: ObservableObject {
    
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
    
    @Published var ramp_rate: String = ""
    @Published var setpt: String = ""
    
    @Published var ts_init_val: String = ""
    @Published var ts_ramp_rate: String = ""
    @Published var ts_setpt: String = ""
    
    @Published var equip_a: String = ""
    @Published var equip_b: String = ""
    
    @Published var time_step: String = ""
    @Published var n_vials: String = ""
    @Published var name: String = ""
}
