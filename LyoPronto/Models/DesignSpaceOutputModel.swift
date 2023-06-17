//
//  DesignSpaceOutputModel.swift
//  LyoPronto
//


import Foundation

import Foundation

struct DSTableOutputModel: Identifiable {
    
    var id = UUID()
    let type: String
    let value: String
    let pressure: Double
    let temperature: Double
    let time: Double
    let sublimationAvg: Double
    let sublimationMax: Double
    let sublimationFinal: Double
    
    init(type: String, value: String, pressure: Double, temperature: Double, time: Double,  sublimationAvg: Double, sublimationMax: Double,  sublimationFinal: Double) {
        self.type = type
        self.value = value
        self.pressure = pressure
        self.temperature = temperature
        self.time = time
        self.sublimationAvg = sublimationAvg
        self.sublimationMax = sublimationMax
        self.sublimationFinal = sublimationFinal
    }
    
    init() {
        self.type = ""
        self.value = ""
        self.pressure = 0.0
        self.temperature = 0.0
        self.time = 0.0
        self.sublimationAvg = 0.0
        self.sublimationMax = 0.0
        self.sublimationFinal = 0.0
    }
}


struct DSGraphOutputModel: Identifiable {
    
    var id = UUID()
    let pressure: Double
    let shelfTemp: [Double]
    let temperature: [Double]
    let time: [Double]
    let sublimation: [Double]
    
    init(pressure: Double, shelfTemp: [Double], temperature: [Double], time: [Double], sublimation: [Double]) {
        self.pressure = pressure
        self.shelfTemp = shelfTemp
        self.temperature = temperature
        self.time = time
        self.sublimation = sublimation
    }
    
    init() {
        self.pressure = 0.0
        self.shelfTemp = [0.0]
        self.temperature = [0.0]
        self.time = [0.0]
        self.sublimation = [0.0]
    }
}


struct AdditionalValuesForDSGraph {
    var minPressure: Double = Double(Int.max)
    var maxPressure: Double = Double(Int.min)
    var minTemperature: Double = Double(Int.max)
    var maxTemperature: Double = Double(Int.min)
    var minTime: Double = Double(Int.max)
    var maxTime: Double = Double(Int.min)
    var minSublimation: Double = Double(Int.max)
    var maxSublimation: Double = Double(Int.min)
    var shortDesc: [String] = [""]
    var description: [String] = [""]
}
