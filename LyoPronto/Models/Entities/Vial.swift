//
//  Vial.swift
//  LyoPronto
//


import Foundation

struct Vial {
    var av: Double = 3.80
    var ap: Double = 3.14
    var vfill: Double = 3.0
}

struct VialPreset {
    var av: String = ""
    var ap: String = ""
    var vfill: String = ""
}

struct PDOtherPreset {
    var time_step: String = ""
}

struct DSOtherPreset {
    var time_step: String = ""
    var num_vials: String = ""
}

struct FreezingOtherPreset {
    var time_step: String = ""
    var h_freezing: String = ""
}

