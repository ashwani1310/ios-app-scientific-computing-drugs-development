//
//  FreezingOutput.swift
//  LyoPronto
//


import Foundation

class FreezingOutputViewModel: ObservableObject {
    
    @Published var freezingCalculatorResult: [[Double]] = [[Double]]()
    var serializedOutput: [FreezingOutputModel] = [FreezingOutputModel]()
    var serializedTableOutput : [FreezingOutputModel] = [FreezingOutputModel]()
    var rangeValues = RangeValuesForFreezingGraph()
    
    func getResult() -> [[Double]] {
        return freezingCalculatorResult
    }
    
    func computeResult(_ userInput: FreezingModel) {
        FreezingCalculatorViewModel._instance.computeResult(userInput) { (res, _) in
            if let res {
                DispatchQueue.main.async {
                    self.freezingCalculatorResult = res
                }
            }
        }
    }
    
    public func getFreezingResult() -> ([FreezingOutputModel], [FreezingOutputModel], RangeValuesForFreezingGraph) {
        
        
        if (self.serializedTableOutput.count < freezingCalculatorResult.count) {
            let resultLength = freezingCalculatorResult.count
            var step_count = 1
            if ( resultLength > 7000){
                step_count = Int(ceil(Double(resultLength)/7000))
            }
            var iterator = 0
            var time = 0.0
            var shelfTemp = 0.0
            var prodTemp = 0.0
           
            for res in freezingCalculatorResult {
                
                self.serializedTableOutput.append(FreezingOutputModel(time: res[0],
                                                                shelfTemperature: res[1],
                                                                productTemperature: res[2]))
                
                time = res[0]
                shelfTemp = res[1]
                prodTemp = res[2]
                
                if (time == Double(Int.max) || time == Double(Int.min) || time == Double("-inf") || time == Double("inf")){
                    time = 0.0
                }
                if (shelfTemp == Double(Int.max) || shelfTemp == Double(Int.min) || shelfTemp == Double("-inf") || shelfTemp == Double("inf")){
                    shelfTemp = 0.0
                }
                if (prodTemp == Double(Int.max) || prodTemp == Double(Int.min) || prodTemp == Double("-inf") || prodTemp == Double("inf")){
                    prodTemp = 0.0
                }
                
                if(iterator%step_count == 0 || iterator == resultLength-1) {
                    self.serializedOutput.append(FreezingOutputModel(time: time,
                                                                    shelfTemperature: shelfTemp,
                                                                    productTemperature: prodTemp))
                }
                iterator += 1
                
                rangeValues.minTime = min(rangeValues.minTime, time)
                rangeValues.maxTime = max(rangeValues.maxTime, time)
                rangeValues.minShelfTemprature = min(rangeValues.minShelfTemprature, shelfTemp)
                rangeValues.maxShelfTemprature = max(rangeValues.maxShelfTemprature, shelfTemp)
                rangeValues.minProductTemprature = min(rangeValues.minProductTemprature, prodTemp)
                rangeValues.maxProductTemprature = max(rangeValues.maxProductTemprature, prodTemp)
            }
        }
        
        
        return (self.serializedOutput, self.serializedTableOutput, self.rangeValues)
    }
    
}

