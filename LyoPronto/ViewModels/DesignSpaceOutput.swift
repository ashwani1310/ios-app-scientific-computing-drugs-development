//
//  DesignSpaceOutput.swift
//  LyoPronto
//


import Foundation

class DesignSpaceOutputViewModel: ObservableObject {
    
    @Published var designSpaceCalculatorResult: [String : [[Double]]] = [String : [[Double]]]()
    @Published var designSpaceResultReady: Bool = false
    var tableOutput: [DSTableOutputModel] = [DSTableOutputModel]()
    var graphOutput: [DSGraphOutputModel] = [DSGraphOutputModel]()
    var addValues = AdditionalValuesForDSGraph()
    
    func getResult() -> [String : [[Double]]] {
        return designSpaceCalculatorResult
    }
    
    func computeResult(_ userInput: DesignSpaceModel) {
        DesignSpaceCalculatorViewModel._instance.computeResult(userInput) { (res, _) in
            if let res {
                DispatchQueue.main.async {
                    self.designSpaceCalculatorResult = res
                    self.designSpaceResultReady = true
                }
            }
        }
        addValues.shortDesc = []
        addValues.description = []
    }
    
    public func getTableData() -> [DSTableOutputModel] {
        if (self.tableOutput.count == 0){
            for (key, values) in designSpaceCalculatorResult{
                if (key == "table_shelf_temperature"){
                    for value in values {
                        self.tableOutput.append(DSTableOutputModel(type: "Shelf Temperature", value: String(format: "%.2f", value[0]), pressure: value[1], temperature: value[2], time: value[3], sublimationAvg: value[4], sublimationMax: value[5], sublimationFinal: value[6]))
                    }
                }
                else if (key == "table_product_temperature"){
                    for value in values {
                        self.tableOutput.append(DSTableOutputModel(type: "Product Temperature", value: String(format: "%.2f", value[0]), pressure: value[1], temperature: value[2], time: value[3], sublimationAvg: value[4], sublimationMax: value[5], sublimationFinal: value[6]))
                    }
                }
                else if (key == "table_equipment_capability"){
                    for value in values {
                        self.tableOutput.append(DSTableOutputModel(type: "Equipment Capability", value: "", pressure: value[0], temperature: value[1], time: value[2], sublimationAvg: value[3], sublimationMax: value[4], sublimationFinal: value[5]))
                    }
                }
                
            }
        }
        
        return self.tableOutput
    }
    
    
    public func getGraphData() -> ([DSGraphOutputModel], AdditionalValuesForDSGraph) {
        if (self.graphOutput.count == 0){
            for (key, values) in designSpaceCalculatorResult{
                if (key.hasPrefix("graph")){
                    let split_key = key.split(separator: "_")
                    var shelfTemp: [Double] = [Double]()
                    var prodTemp: [Double] = [Double]()
                    var dryingTime: [Double] = [Double]()
                    for index in 0..<values[0].count-1 {
                        if((addValues.description.count < values[0].count) || (addValues.shortDesc.count < values[0].count)) {
                            
                            if(index == values[0].count-2){
                                addValues.shortDesc.append("Tpr(\(String(format: "%.2f", values[0][index])) \u{2103})")
                                addValues.description.append("Product Temperature (\(String(format: "%.2f", values[0][index])) \u{2103})")
                            }
                            
                            else{
                                addValues.shortDesc.append("Tsh(\(String(format: "%.2f", values[0][index])) \u{2103})")
                                addValues.description.append("Shelf Temperature (\(String(format: "%.2f", values[0][index])) \u{2103})")
                            }
                        }
                        shelfTemp.append(values[0][index])
                        prodTemp.append(values[1][index])
                        dryingTime.append(values[2][index])
                        addValues.minTemperature = min(addValues.minTemperature, values[1][index])
                        addValues.maxTemperature = max(addValues.maxTemperature, values[1][index])
                        addValues.minTime = min(addValues.minTime, values[2][index])
                        addValues.maxTime = max(addValues.maxTime, values[2][index])
                        addValues.minSublimation = min(addValues.minSublimation, values[3][index])
                        addValues.maxSublimation = max(addValues.maxSublimation, values[3][index])
                    }
                    
                    
                    // For equipment capability
                    if((addValues.description.count < values[3].count) || (addValues.shortDesc.count < values[3].count)) {
                        addValues.shortDesc.append("Eqp Cap")
                        addValues.description.append("Equipment Capability")
                    }
                    addValues.minSublimation = min(addValues.minSublimation, values[3][values[3].count-1])
                    addValues.maxSublimation = max(addValues.maxSublimation, values[3][values[3].count-1])
                    
                    self.graphOutput.append(DSGraphOutputModel(
                        pressure: Double(split_key[split_key.count-1])!,
                        shelfTemp: shelfTemp,
                        temperature: prodTemp,
                        time: dryingTime,
                        sublimation: values[3]))
                    
                    addValues.minPressure = min(addValues.minPressure, Double(split_key[split_key.count-1])!)
                    addValues.maxPressure = max(addValues.maxPressure, Double(split_key[split_key.count-1])!)
                }
            }
        }
        
        return (self.graphOutput, addValues)
    }
    
    
    
    
    
}
