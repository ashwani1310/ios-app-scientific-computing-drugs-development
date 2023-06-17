//
//  PrimaryDryCalculatorViewModel.swift
//  LyoPronto
//

import Foundation

class PrimaryDryOutputViewModel: ObservableObject {
    
    @Published var primaryDryCalculatorResult: [[Double]] = [[Double]]()
    var serializedOutput: [PDOutputModel] = [PDOutputModel]()
    var serializedTableOutput: [PDOutputModel] = [PDOutputModel]()
    var rangeValues = RangeValuesForGraph()
    
    func getResult() -> [[Double]] {
        return primaryDryCalculatorResult
    }
    
    func computeResult(_ userInput: PDModel) {
        PrimaryDryCalculatorViewModel._instance.computeResult(userInput) { (res, _) in
            if let res {
                DispatchQueue.main.async {
                    self.primaryDryCalculatorResult = res
                }
            }
        }
    }
    
    public func getPrimaryDryResult() -> ([PDOutputModel], [PDOutputModel], RangeValuesForGraph) {
        
        if (self.serializedTableOutput.count < primaryDryCalculatorResult.count) {
            let resultLength = primaryDryCalculatorResult.count
            var step_count = 1
            if (resultLength > 7000){
                step_count = Int(ceil(Double(resultLength)/7000))
            }
            var iterator = 0
            var time = 0.0
            var subTemp = 0.0
            var vialTemp = 0.0
            var shelfTemp = 0.0
            var pchamber = 0.0
            var subFlux = 0.0
            var dried = 0.0
            for res in primaryDryCalculatorResult {
                
                self.serializedTableOutput.append(PDOutputModel(time: res[0],
                                                           sublimationTemprature: res[1],
                                                           vialBottomTemprature: res[2],
                                                           shelfTemperature: res[3],
                                                           chamberPressure: res[4],
                                                           sublimationFlux: res[5],
                                                           driedPercent: res[6]))
                
                
                time = res[0]
                subTemp = res[1]
                vialTemp = res[2]
                shelfTemp = res[3]
                pchamber = res[4]
                subFlux = res[5]
                dried = res[6]

                if (time == Double(Int.max) || time == Double(Int.min) || time == Double("-inf") || time == Double("inf")){
                    time = 0.0
                }
                if (subTemp == Double(Int.max) || subTemp == Double(Int.min) || subTemp == Double("-inf") || subTemp == Double("inf")){
                    subTemp = 0.0
                }
                if (vialTemp == Double(Int.max) || vialTemp == Double(Int.min) || vialTemp == Double("-inf") || vialTemp == Double("inf")){
                    vialTemp = 0.0
                }
                if (shelfTemp == Double(Int.max) || shelfTemp == Double(Int.min) || shelfTemp == Double("-inf") || shelfTemp == Double("inf")){
                    shelfTemp = 0.0
                }
                if (pchamber == Double(Int.max) || pchamber == Double(Int.min) || pchamber == Double("-inf") || pchamber == Double("inf")){
                    pchamber = 0.0
                }
                if (subFlux == Double(Int.max) || subFlux == Double(Int.min) || subFlux == Double("-inf") || subFlux == Double("inf")){
                    subFlux = 0.0
                }
                if (dried == Double(Int.max) || dried == Double(Int.min) || dried == Double("-inf") || dried == Double("inf")){
                    dried = 0.0
                }
                
                
                if(iterator%step_count == 0 || iterator == resultLength-1) {
                    self.serializedOutput.append(PDOutputModel(time: time,
                                                              sublimationTemprature: subTemp,
                                                              vialBottomTemprature: vialTemp,
                                                              shelfTemperature: shelfTemp,
                                                              chamberPressure: pchamber,
                                                              sublimationFlux: subFlux,
                                                              driedPercent: dried))
                }
                iterator += 1
                
                
                rangeValues.minTime = min(rangeValues.minTime, time)
                rangeValues.maxTime = max(rangeValues.maxTime, time)
                rangeValues.minSublimationTemprature = min(rangeValues.minSublimationTemprature, subTemp)
                rangeValues.maxSublimationTemprature = max(rangeValues.maxSublimationTemprature, subTemp)
                rangeValues.minVialBottomTemprature = min(rangeValues.minVialBottomTemprature, vialTemp)
                rangeValues.maxVialBottomTemprature = max(rangeValues.maxVialBottomTemprature, vialTemp)
                rangeValues.minShelfTemperature = min(rangeValues.minShelfTemperature, shelfTemp)
                rangeValues.maxShelfTemperature = max(rangeValues.maxShelfTemperature, shelfTemp)
                rangeValues.minChamberPressure = min(rangeValues.minChamberPressure, pchamber)
                rangeValues.maxChamberPressure = max(rangeValues.maxChamberPressure, pchamber)
                rangeValues.minSublimationFlux = min(rangeValues.minSublimationFlux, subFlux)
                rangeValues.maxSublimationFlux = max(rangeValues.maxSublimationFlux, subFlux)
                rangeValues.minDriedPercent = min(rangeValues.minDriedPercent, dried)
                rangeValues.maxDriedPercent = max(rangeValues.maxDriedPercent, dried)
                
            }
        }
        return (self.serializedOutput, self.serializedTableOutput, self.rangeValues)
    }
    
    
    
}
