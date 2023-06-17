//
//  Tshelf.swift
//  LyoPronto
//


import Foundation

struct Tshelf {
    var init_val: Double = -45.0
    var ramp_rate: Double = 1.0
    var setpt: [Double] = [10.0]
    var t_setpt: [Double] = [0.0]
    var dt_setpt: [Double] = [3600.0]
    var min: Double = -45.0
    var max: Double = 120.0
}

struct TshelfPreset {
    var init_val: String = ""
    var ramp_rate: String = ""
    var setpt: String = ""
    var t_setpt: String = ""
    var dt_setpt: String = ""
}

