//
//  FreezingOutputModel.swift
//  LyoPronto
//

import Foundation

struct FreezingOutputModel: Identifiable {
    
    var id = UUID()
    let time: Double
    let shelfTemperature: Double
    let productTemperature: Double
    
    
    init(time: Double, shelfTemperature: Double, productTemperature: Double) {
        self.time = time
        self.shelfTemperature = shelfTemperature
        self.productTemperature = productTemperature
    }
    
    init() {
        self.time = 0.0
        self.shelfTemperature = 0.0
        self.productTemperature = 0.0
    }
}


struct RangeValuesForFreezingGraph {
    var minTime: Double = Double(Int.max)
    var maxTime: Double = Double(Int.min)
    var minShelfTemprature: Double = Double(Int.max)
    var maxShelfTemprature: Double = Double(Int.min)
    var minProductTemprature: Double = Double(Int.max)
    var maxProductTemprature: Double = Double(Int.min)
}

