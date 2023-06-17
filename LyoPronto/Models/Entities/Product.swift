//
//  Product.swift
//  LyoPronto
//


import Foundation

struct Product {
    var csolid: Double = 0.05
    var cr_temp: Double = -5
    var r0: Double = 1.4
    var a1: Double = 16.0
    var a2: Double = 0.0
    var tpr0: Double = 15.8
    var tf: Double = -1.54
    var tn: Double = -5.84
}

struct ProductPreset {
    var csolid: String = ""
    var cr_temp: String = ""
    var r0: String = ""
    var a1: String = ""
    var a2: String = ""
    var tpr0: String = ""
    var tf: String = ""
    var tn: String = ""
}
