//
//  Pchamber.swift
//  LyoPronto
//


import Foundation

struct Pchamber {
    var init_val: Double = 0.0
    var ramp_rate: Double = 0.5
    var setpt: [Double] = [0.1]
    var t_setpt: [Double] = [0.0]
    var dt_setpt: [Double] = [3600.0]
    var min: Double = 0.0
    var max: Double = 1000.0
}

struct PchamberPreset {
    var init_val: String = ""
    var ramp_rate: String = ""
    var setpt: String = ""
    var t_setpt: String = ""
    var dt_setpt: String = ""
}
