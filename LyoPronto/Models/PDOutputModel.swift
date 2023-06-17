//
//  PDOutputModel.swift
//  LyoPronto
//

import Foundation

struct PDOutputModel: Identifiable {
    
    var id = UUID()
    let time: Double
    let sublimationTemprature: Double
    let vialBottomTemprature: Double
    let shelfTemperature: Double
    let chamberPressure: Double
    let sublimationFlux: Double
    let driedPercent: Double
    
    
    init(time: Double, sublimationTemprature: Double, vialBottomTemprature: Double, shelfTemperature: Double, chamberPressure: Double, sublimationFlux: Double, driedPercent: Double) {
        self.time = time
        self.sublimationTemprature = sublimationTemprature
        self.vialBottomTemprature = vialBottomTemprature
        self.shelfTemperature = shelfTemperature
        self.chamberPressure = chamberPressure
        self.sublimationFlux = sublimationFlux
        self.driedPercent = driedPercent
    }
    
    init() {
        self.time = 0.0
        self.sublimationTemprature = 0.0
        self.vialBottomTemprature = 0.0
        self.shelfTemperature = 0.0
        self.chamberPressure = 0.0
        self.sublimationFlux = 0.0
        self.driedPercent = 0.0
    }
}


struct RangeValuesForGraph {
    var minTime: Double = Double(Int.max)
    var maxTime: Double = Double(Int.min)
    var minSublimationTemprature: Double = Double(Int.max)
    var maxSublimationTemprature: Double = Double(Int.min)
    var minVialBottomTemprature: Double = Double(Int.max)
    var maxVialBottomTemprature: Double = Double(Int.min)
    var minShelfTemperature: Double = Double(Int.max)
    var maxShelfTemperature: Double = Double(Int.min)
    var minChamberPressure: Double = Double(Int.max)
    var maxChamberPressure: Double = Double(Int.min)
    var minSublimationFlux: Double = Double(Int.max)
    var maxSublimationFlux: Double = Double(Int.min)
    var minDriedPercent: Double = Double(Int.max)
    var maxDriedPercent: Double = Double(Int.min)
}
